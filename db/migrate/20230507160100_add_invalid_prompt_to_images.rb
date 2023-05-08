class AddInvalidPromptToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :invalid_prompt, :boolean, default: false
  end
end
