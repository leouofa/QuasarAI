class AddInvalidImagesToStories < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :invalid_images, :boolean
  end
end
