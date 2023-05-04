class CreateStoryJob < ApplicationJob
  queue_as :default
  MINIMUM_NUMBER_OF_TAGS_FOR_STORY = 2

  def perform(sub_topic:)
    @sub_topic = sub_topic

    feeds_with_subtopic = Feed.where(sub_topic: sub_topic)
    feeds_with_subtopic_ids = feeds_with_subtopic.pluck(:id)
    # ap feeds_with_subtopic_ids
    #
    feed_items = FeedItem.where(processed: false, feed_id: feeds_with_subtopic_ids)
    feed_items_ids = feed_items.pluck(:id)
    #
    freq_array = {}

    taggings = Tagging.joins(:tag).where(feed_item_id: feed_items_ids)
    taggings.each do |tagging|
      freq_array[tagging.tag.name] = if freq_array[tagging.tag.name].blank?
                                       1
                                     else
                                       freq_array[tagging.tag.name] + 1
                                     end
    end

    sorted_tag_frequency = freq_array.sort { |a,b| b.last <=> a.last }


    # tag_frequency = Tag.joins(taggings: { feed_item: :feed }).where(feed_items: { processed: false }, feeds: { sub_topic_id: sub_topic.id }).group(:name).count(:id)
    # sorted_tag_frequency = tag_frequency.sort { |a,b| b.last <=> a.last }

    # byebug

    # too few tags don't do anything
    return if sorted_tag_frequency.size < 2
    return if sorted_tag_frequency[1][1] < MINIMUM_NUMBER_OF_TAGS_FOR_STORY


    story_tag_name = sorted_tag_frequency[1][0]
    story_tag_frequency = sorted_tag_frequency[1][1]
    tag = Tag.find_by_name(story_tag_name)



    available_feed_items = FeedItem.joins(taggings: :tag).where(id: feed_items_ids, tags: { name: story_tag_name }, feed_items: { processed: false })


    story = Story.new
    story.tag = tag
    story.save


    available_feed_items.sample(MINIMUM_NUMBER_OF_TAGS_FOR_STORY).each do |available_feed_item|
      story.feed_items << available_feed_item
      available_feed_item.update(processed: true)
    end

    ap sorted_tag_frequency
    ap "Creating story for subtopic: #{sub_topic.name}, with tag name: #{story_tag_name} and frequency: #{story_tag_frequency}."



    # tag_frequency = Tag.joins(taggings: {feed_item: :feed}).where(feeds: {id: sub_topic.id}).select("tags.name").group(:name).count
    #  sub_topic.feeds.last.feed_items.last.tags
    #  Tag.joins(taggings: {feed_item: :feed}).where(feeds: {id: sub_topic.id})
    # byebug
  end
end
