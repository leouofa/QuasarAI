class Images::UploadImaginationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Imagination.successful_unuploaded.each do |imagination|
      image_url = imagination.payload['imageUrl']
      uploadcare_rsp = Uploadcare::UploadApi.upload_file(image_url)
      imagination.update!(uploadcare: uploadcare_rsp, uploaded: true)
    end

  end
end
