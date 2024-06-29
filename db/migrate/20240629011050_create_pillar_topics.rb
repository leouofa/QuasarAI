class CreatePillarTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :pillar_topics do |t|
      t.string :title
      t.text :summary
      t.references :pillar_column, null: false, foreign_key: true

      t.timestamps
    end
  end
end
