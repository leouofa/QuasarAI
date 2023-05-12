class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.references :story, null: false, foreign_key: true
      t.text :idea
      t.string :uploaded_url

      t.timestamps
    end
  end
end
