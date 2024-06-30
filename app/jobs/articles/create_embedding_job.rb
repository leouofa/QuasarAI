class Articles::CreateEmbeddingJob < ApplicationJob
  queue_as :default

  def perform(article: )
    @client = OpenAI::Client.new(
      access_token: "lm-studio",
      uri_base: "http://localhost:1234/v1"
    )

    content_string = article.original_text.map do |section|
      "#{section['header']}\n#{section['paragraphs'].join("\n")}"
    end.join("\n\n")

    response = @client.embeddings(
      parameters: {
        model: "nomic-ai/nomic-embed-text-v1.5-GGUF",
        input: content_string
      }
    )

    embedding = response["data"][0]["embedding"]

    article.update(embedding: embedding)
  end
end
