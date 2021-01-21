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

ActiveRecord::Schema.define(version: 2021_01_21_183047) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.integer "street_number"
    t.string "postal_code"
    t.string "region"
    t.string "province"
    t.string "unit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "constituency_id"
    t.index ["constituency_id"], name: "index_addresses_on_constituency_id"
  end

  create_table "constituencies", force: :cascade do |t|
    t.integer "district_number"
    t.string "region"
    t.string "area"
    t.integer "population"
    t.integer "number_of_electors"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "members", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "website"
    t.string "party"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "constituency_id"
    t.index ["constituency_id"], name: "index_members_on_constituency_id"
  end

  add_foreign_key "addresses", "constituencies"
  add_foreign_key "members", "constituencies"
end
