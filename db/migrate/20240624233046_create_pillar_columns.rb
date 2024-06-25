class CreatePillarColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :pillar_columns do |t|
      t.string :name
      t.text :description
      t.references :pillar, null: false, foreign_key: true

      t.timestamps
    end
  end
end
