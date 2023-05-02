class CreateFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :feeds do |t|
      t.references :sub_topic, null: false, foreign_key: true
      t.jsonb :payload

      t.timestamps
    end
  end
end
