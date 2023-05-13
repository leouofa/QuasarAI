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

ActiveRecord::Schema[7.0].define(version: 2023_05_13_012753) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "feed_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_item_id"], name: "index_assignments_on_feed_item_id"
    t.index ["story_id"], name: "index_assignments_on_story_id"
  end

  create_table "feed_items", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.jsonb "payload"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.text "markdown_content"
    t.boolean "processed", default: false
    t.index ["feed_id"], name: "index_feed_items_on_feed_id"
    t.index ["uuid"], name: "index_feed_items_on_uuid", unique: true
  end

  create_table "feeds", force: :cascade do |t|
    t.bigint "sub_topic_id", null: false
    t.jsonb "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false
    t.boolean "error", default: false
    t.index ["sub_topic_id"], name: "index_feeds_on_sub_topic_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "images", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.text "idea"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "invalid_prompt", default: false
    t.boolean "processed", default: false, null: false
    t.index ["story_id"], name: "index_images_on_story_id"
  end

  create_table "imaginations", force: :cascade do |t|
    t.integer "aspect_ratio", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "payload", default: {}, null: false
    t.integer "status", default: 0, null: false
    t.uuid "message_uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "image_id"
    t.boolean "uploaded", default: false, null: false
    t.jsonb "uploadcare"
  end

  create_table "stories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sub_topic_id", null: false
    t.text "stem"
    t.boolean "processed", default: false
    t.boolean "invalid_json", default: false
    t.boolean "invalid_images", default: false
    t.index ["sub_topic_id"], name: "index_stories_on_sub_topic_id"
  end

  create_table "story_tags", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_story_tags_on_story_id"
    t.index ["tag_id"], name: "index_story_tags_on_tag_id"
  end

  create_table "sub_topics", force: :cascade do |t|
    t.string "name"
    t.bigint "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stream_id"
    t.integer "min_tags_for_story"
    t.integer "storypro_category_id"
    t.integer "storypro_user_id"
    t.string "prompts"
    t.index ["topic_id"], name: "index_sub_topics_on_topic_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "feed_item_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_item_id"], name: "index_taggings_on_feed_item_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_access", default: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assignments", "feed_items"
  add_foreign_key "assignments", "stories"
  add_foreign_key "feed_items", "feeds"
  add_foreign_key "feeds", "sub_topics"
  add_foreign_key "images", "stories"
  add_foreign_key "stories", "sub_topics"
  add_foreign_key "story_tags", "stories"
  add_foreign_key "story_tags", "tags"
  add_foreign_key "sub_topics", "topics"
  add_foreign_key "taggings", "feed_items"
  add_foreign_key "taggings", "tags"
end
