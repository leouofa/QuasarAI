module Images
  class CreateImageIdeasFromStoriesJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      stories_without_images = Story.where.not(id: Image.select(:story_id))
                     .where(invalid_images: false, invalid_json: false)

      stories_without_images.each do |story|
        Images::CreateImageIdeaJob.perform_now(story:)
      end
    end
  end
end
