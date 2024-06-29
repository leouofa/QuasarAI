class Pillars::CreatePillarTopicsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PillarColumn.with_topics.unprocessed.each do |pillar_column|
      process_pillar_column(pillar_column:)
    end
  end

  private

  def process_pillar_column(pillar_column:)
    pillar_column.topics.each do |pillar_topic|
      create_pillar_topic(pillar_column: ,pillar_topic:)
    end
    pillar_column.update(processed: true)
  end

  def create_pillar_topic(pillar_column:, pillar_topic:)
    PillarTopic.create!(pillar_column: pillar_column, title: pillar_topic["title"], summary: pillar_topic["summary"])
  end
end
