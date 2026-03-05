class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.references :building, null: false, foreign_key: true
      t.date :room_created_at, null: false

      t.timestamps
    end
  end
end
