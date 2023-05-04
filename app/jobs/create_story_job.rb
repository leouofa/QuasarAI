class CreateStoryJob < ApplicationJob
  queue_as :default
  MINIMUM_NUMBER_OF_TAGS_FOR_STORY = 3

  def perform(sub_topic:)
    @sub_topic = sub_topic

    tag_frequency = Tag.joins(taggings: { feed_item: :feed })
                       .where(feed_items: { processed: false }, feeds: { id: sub_topic.id })
                       .group(:name)
                       .count(:id)
    sorted_tag_frequency = tag_frequency.sort { |a,b| b.last <=> a.last }

    # too few tags don't do anything
    return if sorted_tag_frequency.size < 2
    return if sorted_tag_frequency[1][1] < MINIMUM_NUMBER_OF_TAGS_FOR_STORY

    story_tag_name = sorted_tag_frequency[1][0]
    story_tag_frequency = sorted_tag_frequency[1][1]
    tag = Tag.find_by_name(story_tag_name)



    feed_items = FeedItem.joins(taggings: :tag).where(tags: { name: story_tag_name }, feed_items: { processed: false })

    story = Story.new
    story.tag = tag
    story.save

    feed_items.sample(MINIMUM_NUMBER_OF_TAGS_FOR_STORY).each do |feed_item|
      story.feed_items << feed_item
      feed_item.update(processed: true)
    end

    ap sorted_tag_frequency
    ap "Creating story for subtopic: #{sub_topic.name}, with tag name: #{story_tag_name} and frequency: #{story_tag_frequency}."



    # tag_frequency = Tag.joins(taggings: {feed_item: :feed}).where(feeds: {id: sub_topic.id}).select("tags.name").group(:name).count
    #  sub_topic.feeds.last.feed_items.last.tags
    #  Tag.joins(taggings: {feed_item: :feed}).where(feeds: {id: sub_topic.id})
    # byebug
  end
end
