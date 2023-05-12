module FeedItems
  class CreateFeedItemsJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Feed.unprocessed.each do |feed|
        process_feed(feed)
      end
    end

    private

    def process_feed(feed)
      feed.payload['items'].each do |feed_item|
        create_feed_item(feed, feed_item) unless content_blank?(feed_item)
      end

      feed.update(processed: true)
    end

    def content_blank?(feed_item)
      feed_item['fullContent'].blank? && feed_item['content'].blank?
    end

    def create_feed_item(feed, feed_item)
      attributes = extract_attributes(feed, feed_item)
      new_feed_item = FeedItem.create!(attributes)

      if feed_item['commonTopics'].present?
        process_tags(new_feed_item, feed_item['commonTopics'])
      end
    rescue ActiveRecord::RecordNotUnique => e
      handle_duplicate_uuid(e, attributes[:uuid])
    end

    def extract_attributes(feed, feed_item)
      {
        feed: feed,
        title: feed_item['title'],
        content: feed_item['fullContent'] || feed_item['content'],
        uuid: feed_item['id'],
        author: feed_item['author'],
        crawled: format_unix_time(feed_item['crawled']),
        published: format_unix_time(feed_item['published']),
        url: feed_item['canonicalUrl']
      }
    end

    def process_tags(feed_item, common_topics)
      common_topics.each do |topic|
        tag = Tag.find_or_create_by(name: topic['label'])
        feed_item.tags << tag
      end
    end

    def handle_duplicate_uuid(error, uuid)
      if error.cause.is_a?(PG::UniqueViolation) && error.cause.message.include?('uuid')
        Rails.logger.debug "A record with the UUID '#{uuid}' already exists."
      else
        feed.update(error: true)
        raise error
      end
    end

    def format_unix_time(unix_time)
      time = Time.zone.at(unix_time / 1000.0)
      time.to_date
    end
  end
end
