class AddBoardIdToSubtopics < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_topics, :pinterest_board, :bigint, default: nil
  end
end
