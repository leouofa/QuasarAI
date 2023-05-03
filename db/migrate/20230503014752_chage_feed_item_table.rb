class ChageFeedItemTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :feed_items, :uuid, :uuid
    add_column :feed_items, :uuid, :string
    add_index :feed_items, :uuid, unique: true
  end
end
