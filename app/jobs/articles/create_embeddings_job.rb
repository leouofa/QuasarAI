class Articles::CreateEmbeddingsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Article.without_embedding.each do |article|
      Articles::CreateEmbeddingJob.perform_later(article:)
    end
  end
end
