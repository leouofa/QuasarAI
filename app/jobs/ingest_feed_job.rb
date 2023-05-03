class IngestFeedJob < ApplicationJob
  queue_as :default

  def perform(sub_topic:)
    @sub_topic = sub_topic

    if @sub_topic.feeds.blank?
      ingest_feed
      return
    end

    formatted_today_date = Time.now.utc.to_date.strftime("%m/%d/%Y")
    @last_feed = @sub_topic.feeds.last

    return if @last_feed.created_at.strftime("%m/%d/%Y") == formatted_today_date

    ingest_feed
  end

  def ingest_feed
    feed = Feedly.get_contents(@sub_topic.stream_id)
    Feed.create(sub_topic: @sub_topic, payload: feed)
  end
end
