# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_05_21_083505) do

  create_table "emolevels", force: :cascade do |t|
    t.integer "scale1"
    t.integer "scale2"
    t.integer "scale3"
    t.integer "scale4"
    t.integer "scale5"
    t.integer "emosum"
    t.integer "time"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_emolevels_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "telegram_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "emolevels", "users"
end
