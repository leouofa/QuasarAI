class Articles::IterateThroughPillarColumnsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PillarTopic.unprocessed.each do |pillar_topic|
      begin
        Articles::CreateArticlesJob.perform_now(pillar_topic:)
      rescue Faraday::ServerError
        Rails.logger.error("Faraday::ServerError encountered. Skipping current pillar_topic and moving on to the next.")
        sleep 1.minute
      end
    end
  end
end
