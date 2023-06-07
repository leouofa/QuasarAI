module Feeds
  class CreateFeedsFromSubtopicsJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      sub_topics = SubTopic.active
      sub_topics.each do |sub_topic|
        Feeds::CreateFeedsJob.perform_now(sub_topic:)
      end
    end
  end
end
