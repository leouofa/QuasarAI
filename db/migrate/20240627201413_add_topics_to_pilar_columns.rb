class AddTopicsToPilarColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :pillar_columns, :topics, :text
  end
end
