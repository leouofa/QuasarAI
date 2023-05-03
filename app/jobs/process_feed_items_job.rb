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
        crawled = format_unix_time(feed_item['crawled'])
        published = format_unix_time(feed_item['published'])
        url = feed_item['canonicalUrl']

        begin
          FeedItem.create(feed:, content:, uuid:, author:, crawled:, published:, url:)
        rescue ActiveRecord::RecordNotUnique => e
          if e.cause.is_a?(PG::UniqueViolation) && e.cause.message.include?('uuid')
            # Handle the duplicate UUID case
            puts "A record with the UUID '#{uuid}' already exists."
          else
            # Re-raise the error if it's not related to the UUID unique constraint
            raise e
          end
        end
      end

      feed.update(processed: true)
    end
    # Do something later
  end

  def format_unix_time(unix_time)
    time = Time.zone.at(unix_time / 1000.0)
    time.to_date
  end
end
