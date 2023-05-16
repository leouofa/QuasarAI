module Discussions
  class PublishJob < ApplicationJob
    queue_as :default
    MAX_STORIES_PUBLISHED_AT_A_TIME = 1

    def perform(*args)
      ready_discussions = Discussion.ready_to_upload

      todays_uploaded_discussions_by_subtopic = Discussion.published_today_and_uploaded
                                                          .group('sub_topics.id')
                                                          .select('sub_topics.*, COUNT(discussions.id) AS discussions_count')
                                                          .map do |sub_topic|
        {
          sub_topic: sub_topic,
          discussions_count: sub_topic.discussions_count
        }
      end

      subtopics_with_max_discussions = todays_uploaded_discussions_by_subtopic.select do |hash|
        hash[:discussions_count] >= hash[:sub_topic].max_stories_per_day
      end

      # Extract subtopic_ids from subtopics_with_max_discussions
      subtopic_ids_with_max_discussions = subtopics_with_max_discussions.map { |hash| hash[:sub_topic].id }

      # Exclude discussions that have a sub_topic_id in subtopic_ids_with_max_discussions
      ready_discussions = ready_discussions.where.not(stories: { sub_topic_id: subtopic_ids_with_max_discussions })

      ready_discussions.sample(MAX_STORIES_PUBLISHED_AT_A_TIME).each do |discussion|
        StoryPro::CreateDiscussionJob.perform_now(discussion:)
      end
    end
  end
end
