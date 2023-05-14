module Images
  class MarkUploadedImagesJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Image.unuploaded_with_three_uploaded_imaginations.each do |image|
        image.update!(uploaded: true)
      end
    end
  end
end