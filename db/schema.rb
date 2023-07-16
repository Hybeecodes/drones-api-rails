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

ActiveRecord::Schema[7.0].define(version: 2023_07_16_165659) do
  create_table "drones", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "serial_number"
    t.column "model", "enum('Lightweight','Middleweight','Heavyweight','Cruiserweight')"
    t.float "weight"
    t.float "battery"
    t.column "status", "enum('Idle','Loading','Loaded','Delivering','Delivered','Returning')"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.float "weight"
    t.string "code"
    t.string "image_url"
    t.bigint "drone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drone_id"], name: "index_medications_on_drone_id"
  end

  add_foreign_key "medications", "drones"
end
