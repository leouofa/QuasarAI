class Stories::ModerateStoriesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Story.needs_approval.each do |story|
      Stories::ModerateStoryJob.perform_now(story:)
    end
  end
end
