# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_05_183329) do
  create_table "assets", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.date "last_inspection_date", null: false
    t.string "name", null: false
    t.text "note"
    t.date "purchase_date", null: false
    t.decimal "purchase_price"
    t.integer "room_id", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_assets_on_room_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "address"
    t.date "building_created_at", null: false
    t.string "code", null: false
    t.string "contact_person_email", null: false
    t.string "contact_person_phone", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "building_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.date "room_created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_rooms_on_building_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "api_key"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "full_name", null: false
    t.string "member_code", null: false
    t.string "phone"
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_users_on_api_key"
  end

  add_foreign_key "assets", "rooms"
  add_foreign_key "rooms", "buildings"
end
