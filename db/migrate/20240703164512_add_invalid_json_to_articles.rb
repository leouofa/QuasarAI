class AddInvalidJsonToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :invalid_json, :boolean, default: false
  end
end
