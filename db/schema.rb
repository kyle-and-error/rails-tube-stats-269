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

ActiveRecord::Schema.define(version: 2019_07_23_093258) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "playlists", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id"
    t.index ["creator_id"], name: "index_playlists_on_creator_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "avatar", default: "http://petmedmd.com/images/user-profile.png"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id"
    t.index ["creator_id"], name: "index_videos_on_creator_id"
  end

  create_table "watches", force: :cascade do |t|
    t.boolean "subscription"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "watcher_id"
    t.bigint "creator_id"
    t.index ["creator_id"], name: "index_watches_on_creator_id"
    t.index ["watcher_id"], name: "index_watches_on_watcher_id"
  end

  create_table "youtube_accounts", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "url"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_youtube_accounts_on_user_id"
  end

  add_foreign_key "playlists", "youtube_accounts", column: "creator_id"
  add_foreign_key "videos", "youtube_accounts", column: "creator_id"
  add_foreign_key "watches", "youtube_accounts", column: "creator_id"
  add_foreign_key "watches", "youtube_accounts", column: "watcher_id"
  add_foreign_key "youtube_accounts", "users"
end
