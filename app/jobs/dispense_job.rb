class DispenseJob < ApplicationJob
  queue_as :default

  def perform(*args)
    processed_images = Image.includes(:imaginations).where(processed: true, invalid_prompt: false)

    complete_images = []
    processed_images.each do |image|
      if image.card_imagination.present? && image.card_imagination.uploaded &&
        image.landscape_imagination.present? && image.landscape_imagination.uploaded &&
        image.portrait_imagination.present? && image.portrait_imagination.uploaded

        complete_images << image
      end
    end

    grouped_images = complete_images.group_by(&:story_id)
    story_ids_with_three_images = grouped_images.select { |_, images| images.size == 3 }
    unique_story_ids = story_ids_with_three_images.keys


    stories_to_dispense = Story.where(processed: true, invalid_images: false, id: unique_story_ids)

    last_story = stories_to_dispense.last
    StoryPro::CreateDiscussionJob.perform_now(story: last_story)

  end
end
