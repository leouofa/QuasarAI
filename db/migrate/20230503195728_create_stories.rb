class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.string :prefix
      t.jsonb :payload
      t.boolean :complete

      t.timestamps
    end
  end
end
