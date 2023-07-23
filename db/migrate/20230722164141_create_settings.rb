class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.text :topics
      t.text :prompts
      t.text :tunings

      t.timestamps
    end
  end
end
