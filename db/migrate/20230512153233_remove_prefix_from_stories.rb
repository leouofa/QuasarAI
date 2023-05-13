class RemovePrefixFromStories < ActiveRecord::Migration[7.0]
  def change
    remove_column :stories, :prefix, :string
  end
end
