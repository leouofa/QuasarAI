class AddProcessedToPillarTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :pillar_topics, :processed, :boolean, default: false
  end
end
