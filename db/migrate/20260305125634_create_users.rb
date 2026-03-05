class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :role, null: false
      t.string :email, null: false
      t.string :phone
      t.string :member_code, null: false

      t.timestamps
    end
  end
end
