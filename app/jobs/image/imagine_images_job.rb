class Image::ImagineImagesJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    images_to_process = Image.where(invalid_prompt: false).where.not(processed: true)
    images_to_process.each do |image|
      Images::ImagineImageJob.perform_now(image:)
    end
  end
end
