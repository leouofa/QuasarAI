class AddErrorToFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :error, :boolean, default: false
  end
end
