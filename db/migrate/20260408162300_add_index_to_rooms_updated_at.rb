class AddIndexToRoomsUpdatedAt < ActiveRecord::Migration[8.1]
  def change
    add_index :rooms, :updated_at
  end
end
