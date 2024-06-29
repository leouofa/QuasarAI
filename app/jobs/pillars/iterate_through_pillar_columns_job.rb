class Pillars::IterateThroughPillarColumnsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PillarColumn.without_topics.each do |pillar_column|
      Pillars::CreatePillarColumnTopicsJob.perform_now(pillar_column:)
    end
  end
end
