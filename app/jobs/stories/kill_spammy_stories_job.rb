class Stories::KillSpammyStoriesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Story.spammy_stems.update_all(invalid_json: true, approved: false)
  end
end
