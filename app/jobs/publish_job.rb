class PublishJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Discussions::PublishJob.perform_now
  end
end
