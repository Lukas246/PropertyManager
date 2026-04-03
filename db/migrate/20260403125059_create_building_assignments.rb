class CreateBuildingAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :building_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :building, null: false, foreign_key: true

      t.timestamps
    end
  end
end
