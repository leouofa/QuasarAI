class Articles::RewriteMarkdownFilesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Article.with_rewritten_text_and_published_date.each do |article|
      Articles::RewriteMarkdownFileJob.perform_now(article:)
    end
  end
end
