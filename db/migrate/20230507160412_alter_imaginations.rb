class AlterImaginations < ActiveRecord::Migration[7.0]
  def change
    remove_column :imaginations, :status, :string
    add_column :imaginations, :payload, :jsonb, default: {}, null: false
    add_column :imaginations, :status, :integer, default: 0, null: false
  end
end
