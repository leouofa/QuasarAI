class CreateArticleLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :article_links do |t|
      t.references :article, null: false, foreign_key: true
      t.references :linked_article, polymorphic: true, null: false

      t.timestamps
    end
  end
end
