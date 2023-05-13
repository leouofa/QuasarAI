module Images
  class CreateImageIdeasFromStoriesJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Story.without_images.each do |story|
        Images::CreateImageIdeaJob.perform_now(story:)
      end
    end
  end
end
