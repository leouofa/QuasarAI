class AddProcessedAndInvalidToStories < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :processed, :boolean, default: false
    add_column :stories, :invalid_json, :boolean, default: false
  end
end
