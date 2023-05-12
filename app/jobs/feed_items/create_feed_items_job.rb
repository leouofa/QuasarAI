module FeedItems
  class CreateFeedItemsJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      feeds = Feed.where(processed: false)

      feeds.each do |feed|
        next if feed.processed

        feed.payload['items'].each do |feed_item|
          next if feed_item['fullContent'].blank? && feed_item['content'].blank?

          title = feed_item['title']
          content = feed_item['fullContent'] || feed_item['content']
          uuid = feed_item['id']
          author = feed_item['author']
          crawled = format_unix_time(feed_item['crawled'])
          published = format_unix_time(feed_item['published'])
          url = feed_item['canonicalUrl']

          tags  = feed_item['commonTopics'].collect { |topic| topic['label'] } if feed_item['commonTopics'].present?

          begin
            new_feed_item = FeedItem.create(feed:, title:, content:, uuid:, author:, crawled:, published:, url:)

            if feed_item['commonTopics'].present?
              tags.each do |tag|
                current_tag = Tag.find_or_create_by(name: tag)
                new_feed_item.tags << current_tag
              end
            end
          rescue ActiveRecord::RecordNotUnique => e
            raise e unless e.cause.is_a?(PG::UniqueViolation) && e.cause.message.include?('uuid')

            # Handle the duplicate UUID case
            Rails.logger.debug "A record with the UUID '#{uuid}' already exists."

            # Re-raise the error if it's not related to the UUID unique constraint
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
end
