class AddStoryProIdToDiscussions < ActiveRecord::Migration[7.0]
  def change
    add_column :discussions, :story_pro_id, :integer
  end
end
