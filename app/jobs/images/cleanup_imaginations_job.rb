class Images::CleanupImaginationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    failed_imaginations = Imagination.where("payload ->> 'content' = 'FAILED_TO_PROCESS_YOUR_COMMAND'")
    failed_imaginations.destroy_all
  end
end
