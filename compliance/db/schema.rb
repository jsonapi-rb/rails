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

ActiveRecord::Schema.define(version: 0) do

  create_table "authors", force: :cascade do |t|
    t.text "name", null: false
    t.date "date_of_birth", null: false
    t.date "date_of_death"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "books", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "series_id"
    t.date "date_published", null: false
    t.text "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "books_stores", id: false, force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "store_id", null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.integer "book_id", null: false
    t.text "title", null: false
    t.integer "ordering", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "photos", force: :cascade do |t|
    t.text "title", null: false
    t.text "uri", null: false
    t.integer "imageable_id", null: false
    t.text "imageable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "series", force: :cascade do |t|
    t.text "title", null: false
    t.integer "photo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "stores", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

end
