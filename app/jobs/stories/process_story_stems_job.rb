module Stories
  class ProcessStoryStemsJob < ApplicationJob
    queue_as :default

    def perform(*args)
      Story.all.where(processed: false).each do |story|
        Stories::MakeStemJob.perform_now(story:)
      end
      # Do something later
    end
  end
end
