class Articles::RewriteArticlesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Article.with_three_links_without_rewritten_text.each do |article|
      Articles::RewriteArticleJob.perform_now(article:)
    end
  end
end
