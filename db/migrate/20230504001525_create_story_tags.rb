class CreateStoryTags < ActiveRecord::Migration[7.0]
  def change
    create_table :story_tags do |t|
      t.references :story, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
