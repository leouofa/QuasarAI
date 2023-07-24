class PageController < ApplicationController
  include RestrictedAccess
  def index
    @topics = Topic.with_active_subtopic.order(:name)
    @feeds_count = Feed.count
    @feed_items_count = FeedItem.count
    @stories_count = Story.count
    @discussions_count = Discussion.count
    @imaginations_count = Imagination.count
    @tweets_count = Tweet.count
  end
end
