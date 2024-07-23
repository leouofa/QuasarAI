class Articles::RewriteArticlesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Article.with_three_links_without_rewritten_text.each do |article|
      begin
        Articles::RewriteArticleJob.perform_now(article:)
      rescue Faraday::ServerError
        Rails.logger.error("Faraday::ServerError encountered. Skipping current pillar_topic and moving on to the next.")
        sleep 1.minute
      end
    end
  end
end
