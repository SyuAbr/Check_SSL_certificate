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

ActiveRecord::Schema[7.1].define(version: 2024_07_21_160904) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.string "chat_id"
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "tag_id"], name: "index_chats_on_chat_id_and_tag_id", unique: true
    t.index ["tag_id"], name: "index_chats_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "bot_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags_websites", id: false, force: :cascade do |t|
    t.bigint "website_id", null: false
    t.bigint "tag_id", null: false
    t.index ["tag_id", "website_id"], name: "index_tags_websites_on_tag_id_and_website_id"
    t.index ["website_id", "tag_id"], name: "index_tags_websites_on_website_id_and_tag_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "role", default: "Сотрудник", null: false
    t.string "api_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "deleted_at", precision: nil
    t.index ["api_token"], name: "index_users_on_api_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "websites", force: :cascade do |t|
    t.string "address", null: false
    t.date "certificate_expiration", null: false
    t.integer "user_id", null: false
    t.string "tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tags"], name: "index_websites_on_tags", using: :gin
  end

  add_foreign_key "chats", "tags"
  add_foreign_key "websites", "users"
end
