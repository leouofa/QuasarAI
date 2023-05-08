class Image::ImagineImagesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    images_ids = Image.joins(:imaginations).where(imaginations: {aspect_ratio: :card}).pluck(:id)
    images_to_process = Image.where(invalid_prompt: false).where.not(id: images_ids)
    images_to_process.each do |image|
      Images::ImagineImageJob.perform_now(image:)
      sleep(120)
    end
  end
end
