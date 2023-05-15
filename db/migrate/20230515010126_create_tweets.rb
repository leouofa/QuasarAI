class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.references :discussion, null: false, foreign_key: true
      t.text :stem
      t.boolean :processed, default: false
      t.boolean :invalid_json, default: false
      t.boolean :uploaded, default: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
