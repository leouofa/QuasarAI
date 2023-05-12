class AddFeedToSubTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_topics, :feed, :string
  end
end
