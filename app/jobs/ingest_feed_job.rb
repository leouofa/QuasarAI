class IngestFeedJob < ApplicationJob
  queue_as :default

  def perform(sub_topic:)
    @sub_topic = sub_topic
    @feed = Feed.new(sub_topic:)

    # Do something later
  end
end
