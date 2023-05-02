class AddStreamIdToSubTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_topics, :stream_id, :string
  end
end
