class Pillars::IterateThroughPillarsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Pillar.with_less_columns.each do |pillar|
      Pillars::PopulatePillarColumnsJob.perform_now(pillar:)
    end
  end
end
