class AddPillarsToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :pillars, :text
  end
end
