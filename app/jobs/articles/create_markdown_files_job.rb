class Articles::CreateMarkdownFilesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Article.with_original_text_and_no_published_date.each do |article|
      Articles::CreateMarkdownFileJob.perform_now(article:)
    end
  end
end
