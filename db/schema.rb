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

ActiveRecord::Schema.define(version: 20181120212804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "organization", null: false
    t.string "passcode", limit: 60, null: false
    t.datetime "passcode_expires_at", null: false
    t.string "auth_token", limit: 32, null: false
    t.datetime "account_unlocks_at", null: false
    t.integer "lockout_strikes", default: 0, null: false
    t.integer "total_strikes", default: 0, null: false
    t.integer "sessions_created", default: 0, null: false
    t.index ["auth_token"], name: "index_administrators_on_auth_token"
    t.index ["email"], name: "index_administrators_on_email"
  end

  create_table "image_attachments", force: :cascade do |t|
    t.bigint "image_id"
    t.integer "imageable_id", null: false
    t.string "imageable_type", null: false
    t.string "collection", null: false
    t.integer "weight", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection"], name: "index_image_attachments_on_collection"
    t.index ["image_id"], name: "index_image_attachments_on_image_id"
    t.index ["imageable_id"], name: "index_image_attachments_on_imageable_id"
    t.index ["imageable_type"], name: "index_image_attachments_on_imageable_type"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.string "alt_text", null: false
    t.string "caption"
    t.text "keywords"
    t.string "attribution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_file_name"
    t.string "image_file_content_type"
    t.integer "image_file_file_size"
    t.datetime "image_file_updated_at"
  end

  create_table "miscellany", force: :cascade do |t|
    t.string "key", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.text "value"
    t.index ["key"], name: "index_miscellany_on_key"
  end

  create_table "redirects", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "original_path", null: false
    t.text "target_uri", null: false
    t.text "parameter_preservation_mode", default: "outgoing", null: false
    t.index ["original_path"], name: "index_redirects_on_original_path"
    t.index ["parameter_preservation_mode"], name: "index_redirects_on_parameter_preservation_mode"
    t.index ["target_uri"], name: "index_redirects_on_target_uri"
  end

end
