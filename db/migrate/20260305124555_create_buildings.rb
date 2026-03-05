class CreateBuildings < ActiveRecord::Migration[8.1]
  def change
    create_table :buildings do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :address
      t.string :contact_person_email, null: false
      t.string :contact_person_phone, null: false
      t.date :building_created_at, null: false

      t.timestamps
    end
  end
end
