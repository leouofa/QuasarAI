class DispenseJob < ApplicationJob
  queue_as :default

  def perform(*args)
    complete_images = find_complete_images
    unique_story_ids = find_unique_story_ids(complete_images)
    stories_to_dispense = find_stories_to_dispense(unique_story_ids)

    stories_to_dispense.each do |story|
      StoryPro::CreateDiscussionJob.perform_now(story: story)
    end
  end

  private

  def find_complete_images
    processed_images = Image.preload(:imaginations)
                            .where(processed: true, invalid_prompt: false)
    complete_images = []

    processed_images.each do |image|
      complete_images << image if all_imagination_types_uploaded?(image)
    end

    complete_images
  end

  def all_imagination_types_uploaded?(image)
    image.card_imagination.present? && image.card_imagination.uploaded &&
      image.landscape_imagination.present? && image.landscape_imagination.uploaded &&
      image.portrait_imagination.present? && image.portrait_imagination.uploaded
  end

  def find_unique_story_ids(complete_images)
    grouped_images = complete_images.group_by(&:story_id)
    story_ids_with_three_images = grouped_images.select { |_, images| images.size == 3 }
    unique_story_ids = story_ids_with_three_images.keys
  end

  def find_stories_to_dispense(unique_story_ids)
    Story.where(processed: true, invalid_images: false, invalid_json: false, id: unique_story_ids)
  end
end
