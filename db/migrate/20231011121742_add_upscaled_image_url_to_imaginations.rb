class AddUpscaledImageUrlToImaginations < ActiveRecord::Migration[7.0]
  def change
    add_column :imaginations, :upscaled_image_url, :string
  end
end
