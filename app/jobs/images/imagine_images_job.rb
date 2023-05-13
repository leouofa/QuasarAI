module Images
  class ImagineImagesJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Image.to_process.each do |image|
        Images::ImagineImageJob.perform_now(image:)
      end
    end
  end
end
