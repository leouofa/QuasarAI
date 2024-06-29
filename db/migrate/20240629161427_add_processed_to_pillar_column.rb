class AddProcessedToPillarColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :pillar_columns, :processed, :boolean, default: false
  end
end
