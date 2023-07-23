module Stories
  class CreateStoriesJob < ApplicationJob
    queue_as :default
    MINIMUM_TAG_ARRAY_SIZE = 2

    def perform(sub_topic:)
      process_sub_topic(sub_topic: sub_topic)
    end

    def process_sub_topic(sub_topic:)
      feeds_filtered_by_subtopic = Feed.where(sub_topic: sub_topic)
      feed_ids_filtered_by_subtopic = feeds_filtered_by_subtopic.pluck(:id)

      unprocessed_feed_items = FeedItem.where(processed: false, feed_id: feed_ids_filtered_by_subtopic)
      unprocessed_feed_items_ids = unprocessed_feed_items.pluck(:id)

      unprocessed_tag_frequency = Tag.joins(taggings: { feed_item: :feed })
                                     .where(feed_items: { processed: false }, feeds: { sub_topic_id: sub_topic.id })
                                     .where.not(feed_items: { markdown_content: nil })
                                     .group(:name).count(:id)
      sorted_unprocessed_tag_frequency = unprocessed_tag_frequency.sort { |a, b| b.last <=> a.last }

      # Removing excluded tags
      excluded_tags = ApplicationController.helpers.s('excluded_tags')
      if excluded_tags.present?
        sorted_unprocessed_tag_frequency.delete_if { |entry| excluded_tags.include?(entry[0]) }
      end

      # too few tags don't do anything
      return if sorted_unprocessed_tag_frequency.size < MINIMUM_TAG_ARRAY_SIZE
      return if sorted_unprocessed_tag_frequency[0][1] < sub_topic.min_tags_for_story

      story_tag_name, story_tag_frequency = sorted_unprocessed_tag_frequency.first
      tag = Tag.find_by(name: story_tag_name)

      available_feed_items = FeedItem.joins(taggings: :tag)
                                     .where(id: unprocessed_feed_items_ids,
                                            tags: { name: story_tag_name },
                                            feed_items: { processed: false })

      story = Story.create(tag: tag, sub_topic: sub_topic)

      available_feed_items.sample(sub_topic.min_tags_for_story).each do |available_feed_item|
        story.feed_items << available_feed_item
        available_feed_item.update(processed: true)
      end

      log_processing_info(sub_topic, story_tag_name, story_tag_frequency, sorted_unprocessed_tag_frequency)

      process_sub_topic(sub_topic: sub_topic)
    end

    def log_processing_info(sub_topic, story_tag_name, story_tag_frequency, sorted_unprocessed_tag_frequency)
      Rails.logger.debug "\nPROCESSING:: ================BEGIN====================="
      Rails.logger.debug "\nPROCESSING:: #{sorted_unprocessed_tag_frequency.inspect}."
      Rails.logger.debug "\nPROCESSING:: Creating story for subtopic: #{sub_topic.name}, with tag name: #{story_tag_name} and frequency: #{story_tag_frequency}."
      Rails.logger.debug "\nPROCESSING:: ================END======================="
      Rails.logger.debug "\n"
    end
  end
end
