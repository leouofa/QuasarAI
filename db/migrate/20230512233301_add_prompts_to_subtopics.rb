class AddPromptsToSubtopics < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_topics, :prompts, :string, default: nil
  end
end
