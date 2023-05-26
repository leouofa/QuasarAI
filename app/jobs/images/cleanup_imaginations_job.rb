class Images::CleanupImaginationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    failed_or_full_imaginations = Imagination.where("payload ->> 'content' = 'FAILED_TO_PROCESS_YOUR_COMMAND' OR payload ->> 'content' = 'QUEUE_FULL'")
    failed_or_full_imaginations.destroy_all

    incomplete_image_ids  = Image.without_three_uploaded_imaginations
                                 .where(processed: true).pluck(:id)
    incomplete_images = Image.where(id: incomplete_image_ids)
    incomplete_images.update_all(processed: false)
  end
end
