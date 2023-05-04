module Stories
  class CreateStoriesJob < ApplicationJob
    queue_as :default
    MINIMUM_NUMBER_OF_TAGS_FOR_STORY = 2

    def perform(sub_topic:)
      process_sub_topic(sub_topic: sub_topic)
    end

    def process_sub_topic(sub_topic:)
      feeds_filtered_by_subtopic = Feed.where(sub_topic:)
      feed_ids_filtered_by_subtopic = feeds_filtered_by_subtopic.pluck(:id)

      unprocessed_feed_items = FeedItem.where(processed: false, feed_id: feed_ids_filtered_by_subtopic)
      unprocessed_feed_items_ids = unprocessed_feed_items.pluck(:id)

      unprocessed_tag_frequency = Tag.joins(taggings: { feed_item: :feed })
                                     .where(feed_items: { processed: false }, feeds: { sub_topic_id: sub_topic.id })
                                     .group(:name).count(:id)
      sorted_unprocessed_tag_frequency = unprocessed_tag_frequency.sort { |a, b| b.last <=> a.last }


      # too few tags don't do anything
      return if sorted_unprocessed_tag_frequency.size < 2
      return if sorted_unprocessed_tag_frequency[1][1] < MINIMUM_NUMBER_OF_TAGS_FOR_STORY

      story_tag_name = sorted_unprocessed_tag_frequency[1][0]
      story_tag_frequency = sorted_unprocessed_tag_frequency[1][1]
      tag = Tag.find_by(name: story_tag_name)

      available_feed_items = FeedItem.joins(taggings: :tag)
                                     .where(id: unprocessed_feed_items_ids,
                                            tags: { name: story_tag_name },
                                            feed_items: { processed: false })

      story = Story.new
      story.tag = tag
      story.save

      available_feed_items.sample(MINIMUM_NUMBER_OF_TAGS_FOR_STORY).each do |available_feed_item|
        story.feed_items << available_feed_item
        available_feed_item.update(processed: true)
      end

      Rails.logger.debug "Creating story for subtopic: #{sub_topic.name}, with tag name: #{story_tag_name} and frequency: #{story_tag_frequency}."

      process_sub_topic(sub_topic: sub_topic)
    end
  end
end
