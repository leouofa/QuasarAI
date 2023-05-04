class AddMinNumberOfTagsForStoryToSubTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_topics, :min_tags_for_story, :integer
    remove_column :sub_topics, :feed, :string
  end
end
