class PageController < ApplicationController
  include RestrictedAccess
  def index
    @topics = Topic.with_active_subtopic.order(:name)

    @pending_stories_count = Story.needs_approval.count
    @unpublished_discussions = Discussion.unpublished.count
    @pending_tweets = Tweet.needs_approval.count

    @published_discussions = Discussion.published.count
    @published_tweets = Tweet.published.count

    @denied_stories = Story.denied_stories.count
    @denied_tweets = Tweet.denied.count

    @approved_stories = Story.approved_stories.count
    @approved_tweets = Tweet.approved_tweets.count

    @feeds_count = Feed.count
    @feed_items_count = FeedItem.count
    @stories_count = Story.count
    @discussions_count = Discussion.count
    @imaginations_count = Imagination.count
    @tweets_count = Tweet.count
  end
end
