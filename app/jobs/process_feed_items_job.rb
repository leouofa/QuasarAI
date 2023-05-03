class ProcessFeedItemsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    feeds = Feed.where("created_at >= ? AND created_at <= ?",
                       Time.zone.now.utc.beginning_of_day, Time.zone.now.utc.end_of_day)

    feeds.each do |feed|
      next if feed.processed

      feed.payload['items'].each do |feed_item|
        next if feed_item['fullContent'].blank? && feed_item['content'].blank?

        content = feed_item['fullContent'] || feed_item['content']
        uuid = feed_item['id']
        author = feed_item['author']
        crawled = feed_item['crawled']
        published = feed_item['published']
        url = feed_item['canonicalUrl']

        FeedItem.create(feed:, content:, uuid:, author:, crawled:, published:, url:)
      end

      feed.update(processed: true)
    end
    # Do something later
  end
end
