class CreateInstapins < ActiveRecord::Migration[7.0]
  def change
    create_table :instapins do |t|
      t.references :discussion, null: false, foreign_key: true
      t.text :stem
      t.boolean :processed, default: false
      t.boolean :invalid_json, default: false
      t.boolean :uploaded, default: false
      t.boolean :approved
      t.datetime :published_at

      t.timestamps
    end
  end
end
