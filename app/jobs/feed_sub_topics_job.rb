class FeedSubTopicsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    sub_topics = SubTopic.all
    sub_topics.each do |sub_topic|
      IngestFeedJob.perform_later(sub_topic:)
    end
  end
end
