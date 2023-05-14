class AddPublishedDateToDiscussions < ActiveRecord::Migration[7.0]
  def change
    add_column :discussions, :published_at, :datetime
  end
end
