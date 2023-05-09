class AddProcessedToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :processed, :boolean, default: false, null: false
    remove_column :images, :uploaded_url, :string
  end
end
