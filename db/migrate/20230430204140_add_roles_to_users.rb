class AddRolesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :has_access, :boolean, default: false
    add_column :users, :admin, :boolean, default: false
  end
end
