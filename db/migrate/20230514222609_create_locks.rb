class CreateLocks < ActiveRecord::Migration[6.0]
  def change
    create_table :locks do |t|
      t.string :name, null: false
      t.boolean :locked, default: false

      t.timestamps
    end

    add_index :locks, :name, unique: true
  end
end
