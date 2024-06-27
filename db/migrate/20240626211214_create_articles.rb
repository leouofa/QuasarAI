class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.string :description
      t.references :pillar_column, null: false, foreign_key: true
      t.text :original_text
      t.text :rewritten_text
      t.datetime :published_at
      t.datetime :rewritten_at

      t.timestamps
    end
  end
end
