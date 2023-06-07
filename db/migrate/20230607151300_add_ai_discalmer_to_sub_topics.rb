class AddAiDiscalmerToSubTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_topics, :ai_disclaimer, :boolean, default: false
  end
end
