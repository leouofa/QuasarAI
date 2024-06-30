class AddEmbeddingToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :embedding, :vector, limit: 768
  end
end
