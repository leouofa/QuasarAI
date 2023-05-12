class Images::UploadImaginationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    imaginations =  Imagination.where(status: :success, uploaded: false)
    imaginations.each do |imagination|
      image_url = imagination.payload['imageUrl']

      uploadcare_rsp = Uploadcare::UploadApi.upload_file(image_url)
      imagination.uploadcare = uploadcare_rsp
      imagination.uploaded = true
      imagination.save!
    end

    puts '--'
  end
end
