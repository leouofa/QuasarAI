class RemoveCompleteFromStories < ActiveRecord::Migration[7.0]
  def change
    remove_column :stories, :complete, :boolean
  end
end
