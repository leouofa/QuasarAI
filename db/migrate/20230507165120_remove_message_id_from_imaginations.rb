class RemoveMessageIdFromImaginations < ActiveRecord::Migration[7.0]
  def change
    add_column :imaginations, :message_uuid, :uuid, default: 'gen_random_uuid()', null: false
    remove_column :imaginations, :message_id, :string
  end
end
