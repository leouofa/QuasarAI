class UpdateSettingsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @settings = Setting.instance
    topics = YAML.load(@settings.topics)["topics"]

    topic_names = topics.map { |sub_topic| sub_topic["name"] }
    dead_topics = Topic.where.not(name: topic_names)

    # set subtopics for dead topics to inactive
    dead_topics.each do |dead_topic|
      dead_topic.sub_topics.update_all(active: false)
    end

    topics.each do |topic|
      current_topic = Topic.find_or_create_by name: topic["name"]
      sub_topic_names = topic["sub_topics"].map { |sub_topic| sub_topic["name"] }

      # Set sub_topics not present in the topics.yml to inactive
      current_topic.sub_topics.where.not(name: sub_topic_names).update_all(active: false)

      topic["sub_topics"].each do |sub_topic|
        current_sub_topic_topic = SubTopic.find_or_create_by! name: sub_topic["name"],
                                                              topic_id: current_topic.id
        current_sub_topic_topic.update!(stream_id: sub_topic["stream_id"],
                                        min_tags_for_story: sub_topic["min_tags_for_story"],
                                        max_stories_per_day: sub_topic["max_stories_per_day"],
                                        storypro_category_id: sub_topic["storypro_category_id"],
                                        storypro_user_id: sub_topic["storypro_user_id"],
                                        ai_disclaimer: sub_topic["ai_disclaimer"],
                                        prompts: sub_topic["prompts"],
                                        active: true)
      end
    end

    # delete unprocessed stories with inactive subtopics
    dead_stories = Story.unprocessed.joins(:sub_topic).where(sub_topics: { active: false })
    dead_stories.destroy_all
  end
end
