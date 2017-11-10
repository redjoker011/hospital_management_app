# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130914013108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comment_types", id: :serial, force: :cascade do |t|
    t.string "comment_type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "controllers", id: :serial, force: :cascade do |t|
    t.string "Sessions"
    t.string "new"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "phone"
    t.string "email_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_patients", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "patient_id"
    t.text "comments"
    t.decimal "amount"
    t.integer "comment_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "archive"
  end

  create_table "user_types", id: :serial, force: :cascade do |t|
    t.string "user_type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email_id"
    t.integer "user_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password"
    t.string "salt"
  end

end
