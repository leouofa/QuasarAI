class AddActiveToSubTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_topics, :active, :boolean, default: true
  end
end
