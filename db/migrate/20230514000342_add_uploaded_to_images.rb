class AddUploadedToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :uploaded, :boolean, default: false
  end
end
