class Articles::IterateThroughPillarColumnsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PillarColumn.all.each do |pillar_column|
      Articles::CreateArticlesJob.perform_now(pillar_column:)
    end
  end
end
