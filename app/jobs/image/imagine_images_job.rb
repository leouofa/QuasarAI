class Image::ImagineImagesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    images_to_process = Image.where(invalid_prompt: false).where.not(processed: true)
    images_to_process.each do |image|
      Images::ImagineImageJob.perform_now(image:)

      throttle_requests
    end
  end

  def throttle_requests
    pending_imaginations = Imagination.where(status: :pending).count

    if pending_imaginations > 3
      sleep(300)
    elsif pending_imaginations > 2
      sleep(180)
    else
      sleep(120)
    end
  end
end
