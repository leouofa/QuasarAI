class AddPublishStartTimeToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :publish_start_time, :time, default: '08:00'
    add_column :settings, :publish_end_time, :time, default: '21:00'
  end
end
