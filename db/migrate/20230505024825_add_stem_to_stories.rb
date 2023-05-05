class AddStemToStories < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :stem, :text
  end
end
