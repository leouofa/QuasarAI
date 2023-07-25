class Tweets::PublishJob < ApplicationJob
  queue_as :default
  MAX_TWEETS_PUBLISHED_AT_A_TIME = 1

  def perform(*args)
    settings = Setting.instance
    return unless settings.within_publish_window?

    Discussion.ready_to_upload_tweets.sample(MAX_TWEETS_PUBLISHED_AT_A_TIME).each do |discussion|
      Tweets::PublishTweetJob.perform_now(discussion:)
    end
  end
end
