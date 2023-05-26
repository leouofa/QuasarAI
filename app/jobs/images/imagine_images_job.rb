module Images
  class ImagineImagesJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      # Clear out pending and upscaling imaginations
      Imagination.where(status: [:pending, :upscaling]).delete_all

      # Try to acquire a lock
      lock = Lock.find_or_create_by(name: 'ImagineImagesJob')

      return if lock.locked?

      # Lock the job
      lock.update(locked: true)

      begin
        Image.to_process.each do |image|
          Images::ImagineImageJob.perform_now(image:)

          # We want to stop image processing if the que is full
          # The processing will be restarted next time the job runs
          que_lock = Lock.find_or_create_by(name: 'QueueFull')
          if que_lock.locked?
            que_lock.update(locked: false)
            break
          end
        end
      ensure
        # Unlock the job when finished
        lock.update(locked: false)
      end
    end
  end
end
