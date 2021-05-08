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

ActiveRecord::Schema.define(version: 2021_04_27_194750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "invites", force: :cascade do |t|
    t.bigint "to_user_id"
    t.bigint "from_user_id"
    t.string "message"
    t.boolean "accepted", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["accepted"], name: "index_invites_on_accepted"
    t.index ["from_user_id"], name: "index_invites_on_from_user_id"
    t.index ["to_user_id"], name: "index_invites_on_to_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "invite_id"
    t.text "text"
    t.integer "sender_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "delivered", default: false
    t.index ["invite_id"], name: "index_messages_on_invite_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_skills_on_name"
    t.index ["name"], name: "trgm_idx_skills_name", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "user_skills", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "skill_id"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "phone_number"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar"
    t.string "short_bio"
    t.text "looking_for"
    t.text "long_bio"
    t.float "experience"
    t.integer "age"
    t.string "external_link"
    t.string "location"
    t.index ["email"], name: "index_users_on_email"
    t.index ["phone_number"], name: "index_users_on_phone_number"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "invites", "users", column: "from_user_id"
  add_foreign_key "invites", "users", column: "to_user_id"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
end
