class AddSubTopicReferenceToStories < ActiveRecord::Migration[7.0]
  def change
    add_reference :stories, :sub_topic, null: false, foreign_key: true
  end
end
