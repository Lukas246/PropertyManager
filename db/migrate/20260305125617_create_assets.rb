class CreateAssets < ActiveRecord::Migration[8.1]
  def change
    create_table :assets do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.references :room, null: false, foreign_key: true
      t.date :purchase_date, null: false
      t.date :last_inspection_date, null: false
      t.text :note
      t.decimal :purchase_price

      t.timestamps
    end
  end
end
