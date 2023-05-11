class AddStoryproCategoryIdToSubTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_topics, :storypro_category_id, :integer
    add_column :sub_topics, :storypro_user_id, :integer
  end
end
