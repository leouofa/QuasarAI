class RemoveUploadErrorFromImaginations < ActiveRecord::Migration[7.0]
  def change
    remove_column :imaginations, :upload_error, :boolean
  end
end
