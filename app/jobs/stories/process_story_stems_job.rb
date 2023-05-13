module Stories
  class ProcessStoryStemsJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Story.unprocessed.each do |story|
        Stories::MakeStemJob.perform_now(story:)
      end
    end
  end
end
