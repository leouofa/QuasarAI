class SetDefaultValueForInvalidImagesInStories < ActiveRecord::Migration[7.0]
  def change
    change_column_default :stories, :invalid_images, false
  end
end
