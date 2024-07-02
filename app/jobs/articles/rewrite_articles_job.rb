class Articles::RewriteArticlesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Article.with_three_links.each do |article|
      Articles::RewriteArticleJob.perform_now(article:)
    end
  end
end
