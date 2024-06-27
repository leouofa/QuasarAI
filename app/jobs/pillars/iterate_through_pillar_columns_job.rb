class Pillars::IterateThroughPillarColumnsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PillarColumn.all.each do |pillar_column|
      Pillars::CreatePillarColumnTopicsJob.perform_now(pillar_column:)
    end
  end
end
