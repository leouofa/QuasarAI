class AddProcessedToFeedItems < ActiveRecord::Migration[7.0]
  def change
    add_column :feed_items, :processed, :boolean, default: false
  end
end
