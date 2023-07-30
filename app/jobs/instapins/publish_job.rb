class Instapins::PublishJob < ApplicationJob
  queue_as :default
  MAX_INSTAPINS_PUBLISHED_AT_A_TIME = 1

  def perform(*args)
    settings = Setting.instance
    return unless settings.within_publish_window?

    Discussion.ready_to_upload_instapins.sample(MAX_INSTAPINS_PUBLISHED_AT_A_TIME).each do |discussion|
      Instapins::PublishInstapinJob.perform_now(discussion:)
    end
  end
end
