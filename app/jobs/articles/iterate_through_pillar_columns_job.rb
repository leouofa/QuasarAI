class Articles::IterateThroughPillarColumnsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PillarTopic.unprocessed.each do |pillar_topic|
      Articles::CreateArticlesJob.perform_now(pillar_topic:)
    end
  end
end
