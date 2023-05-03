class CreateFeedItems < ActiveRecord::Migration[7.0]
  def change
    create_table :feed_items do |t|
      t.references :feed, null: false, foreign_key: true
      t.jsonb :payload
      t.text :content
      t.uuid :uuid

      t.timestamps
    end

    add_index :feed_items, :uuid, unique: true
  end
end