class Instapins::ProcessInstapinStemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Discussion.ready_to_create_instapins.each do |discussion|
      Instapins::MakeStemJob.perform_now(discussion:)
    end
  end
end
