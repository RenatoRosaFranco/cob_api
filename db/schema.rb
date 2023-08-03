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

ActiveRecord::Schema[7.0].define(version: 2023_08_03_161159) do
  create_table "athletes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "competition_athletes", force: :cascade do |t|
    t.integer "competition_id", null: false
    t.integer "athlete_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_id"], name: "index_competition_athletes_on_athlete_id"
    t.index ["competition_id"], name: "index_competition_athletes_on_competition_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "max_attempts", default: 1
  end

  create_table "results", force: :cascade do |t|
    t.integer "competition_id", null: false
    t.integer "athlete_id", null: false
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_id"], name: "index_results_on_athlete_id"
    t.index ["competition_id"], name: "index_results_on_competition_id"
  end

  add_foreign_key "competition_athletes", "athletes"
  add_foreign_key "competition_athletes", "competitions"
  add_foreign_key "results", "athletes"
  add_foreign_key "results", "competitions"
end
