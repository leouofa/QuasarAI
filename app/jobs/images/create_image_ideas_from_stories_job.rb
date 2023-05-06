class Images::CreateImageIdeasFromStoriesJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    stories_with_no_images = Story.where.not(id: Image.select(:story_id))
                                  .where(processed: true)
                                  .where('invalid_images = ? OR invalid_images IS NULL', false)
                                  .where('invalid_json = ? OR invalid_json IS NULL', false)

    stories_with_no_images.each do |story|
      Images::CreateImageIdeaJob.perform_now(story:)
    end
  end
end
