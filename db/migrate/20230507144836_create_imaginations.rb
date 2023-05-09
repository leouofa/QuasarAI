class CreateImaginations < ActiveRecord::Migration[7.0]
  def change
    create_table :imaginations do |t|
      t.integer :aspect_ratio, null: false
      t.string :message_id
      t.string :status
      t.references :image, null: false, foreign_key: true

      t.timestamps
    end
  end
end
