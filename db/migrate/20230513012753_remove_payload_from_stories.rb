class RemovePayloadFromStories < ActiveRecord::Migration[7.0]
  def change
    remove_column :stories, :payload, :jsonb
  end
end
