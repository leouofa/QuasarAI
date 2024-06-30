class Articles::CreateLinksJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Article.without_three_links.each do |article|
      links = article.nearest_neighbors(:embedding, distance: "euclidean").first(3)

      # Append the links to the article
      links.each do |linked_article|
        # Check if the article already has 3 links
        break if article.linked_articles.count >= 3

        # Create the article link unless it already exists
        unless article.linked_articles.include?(linked_article)
          article.linked_articles << linked_article
        end
      end
    end
  end
end
