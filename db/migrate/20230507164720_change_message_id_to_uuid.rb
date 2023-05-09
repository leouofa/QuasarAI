class ChangeMessageIdToUuid < ActiveRecord::Migration[7.0]
  def change
    # Add a new temporary column for UUIDs
    add_column :imaginations, :message_uuid, :uuid

    # Copy the data from message_id to message_uuid
    Imagination.reset_column_information
    Imagination.find_each { |imagination| imagination.update!(message_uuid: imagination.message_id) }

    # Remove the old message_id column
    remove_column :imaginations, :message_id

    # Rename the temporary column to message_id
    rename_column :imaginations, :message_uuid, :message_id
    end
end
