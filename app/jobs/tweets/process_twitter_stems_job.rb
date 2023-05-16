class Tweets::ProcessTwitterStemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Discussion.ready_to_make_tweets.each do |discussion|
      Tweets::MakeStemJob.perform_now(discussion:)
    end
  end
end
