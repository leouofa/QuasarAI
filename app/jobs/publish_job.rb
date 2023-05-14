class PublishJob < ApplicationJob
  queue_as :default

  def perform(*args)
    formatted_today_date = Time.now.utc.to_date.strftime("%m/%d/%Y")

    # Do something later
    # discussion = Discussion.last
    Discussion.ready_to_upload.each do |discussion|
      StoryPro::CreateDiscussionJob.perform_now(discussion:)
    end
  end
end
