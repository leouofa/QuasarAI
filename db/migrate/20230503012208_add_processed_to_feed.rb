class AddProcessedToFeed < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :processed, :boolean, default: false
  end
end
