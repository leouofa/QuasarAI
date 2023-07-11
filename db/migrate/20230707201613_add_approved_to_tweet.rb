class AddApprovedToTweet < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :approved, :boolean
  end
end
