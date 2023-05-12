module Images
  class CreateImageIdeasFromStoriesJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      # TODO ensure that changing this query did not break anything. Specifically the `processed: true` part.
      # stories_with_no_images = Story.where.not(id: Image.select(:story_id).where(processed: true))
      #                               .where(invalid_images: false, invalid_json: false)

      stories_without_images = Story.where.not(id: Image.select(:story_id))
                     .where(invalid_images: false, invalid_json: false)

      stories_without_images.each do |story|
        Images::CreateImageIdeaJob.perform_now(story:)
      end
    end
  end
end
