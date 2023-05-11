class AddUploadedToImaginations < ActiveRecord::Migration[7.0]
  def change
    add_column :imaginations, :uploaded, :boolean, default: false, null: false
    add_column :imaginations, :upload_error, :boolean, default: nil
    add_column :imaginations, :uploadcare, :jsonb, default: nil
  end
end
