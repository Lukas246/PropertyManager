class CreateBuildingNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :building_notes do |t|
      t.references :building, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
