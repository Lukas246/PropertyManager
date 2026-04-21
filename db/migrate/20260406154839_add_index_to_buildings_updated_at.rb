class AddIndexToBuildingsUpdatedAt < ActiveRecord::Migration[7.0]
  def change
    add_index :buildings, :updated_at
  end
end
