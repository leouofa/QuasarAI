class AddMaxStoriesPerDayToSubTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_topics, :max_stories_per_day, :integer
  end
end
