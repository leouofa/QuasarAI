class Discussions::ProcessDiscussionStemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Story.with_stem_and_valid_processed_images_no_discussions.each do |story|
      Discussions::MakeStemJob.perform_now(story:)
    end
  end
end
