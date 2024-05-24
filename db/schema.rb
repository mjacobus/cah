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

ActiveRecord::Schema[7.1].define(version: 2024_05_24_202729) do
  create_table "addresses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "householder_name"
    t.string "phone_number"
    t.string "street_name"
    t.string "number"
    t.string "complement"
    t.string "postal_code"
    t.string "neighborhood"
    t.string "city_name"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.boolean "verified"
    t.bigint "congregation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["congregation_id"], name: "index_addresses_on_congregation_id"
  end

  create_table "circuits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "overseer_name"
    t.string "overseer_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_circuits_on_name", unique: true
  end

  create_table "congregations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.string "contact_person_name"
    t.string "contact_person_phone_number"
    t.string "city_name"
    t.string "address"
    t.bigint "circuit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["circuit_id"], name: "index_congregations_on_circuit_id"
    t.index ["name", "circuit_id"], name: "index_congregations_on_name_and_circuit_id", unique: true
    t.index ["number"], name: "index_congregations_on_number", unique: true
  end

  add_foreign_key "addresses", "congregations"
end
