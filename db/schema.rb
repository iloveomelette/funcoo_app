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

ActiveRecord::Schema.define(version: 2022_05_10_130552) do

  create_table "favorites", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_favorites_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_favorites_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "genres", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.integer "staple_food", default: 0, null: false
    t.integer "main_dish", default: 0, null: false
    t.integer "side_dish", default: 0, null: false
    t.integer "country_dish", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_genres_on_recipe_id"
  end

  create_table "level_settings", charset: "utf8mb4", force: :cascade do |t|
    t.integer "passing_level"
    t.integer "threshold"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "makes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_makes_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_makes_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_makes_on_user_id"
  end

  create_table "recipes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "content", null: false
    t.string "menu_image"
    t.integer "cooking_time"
    t.integer "cooking_cost"
    t.integer "calorie"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "makes_count", default: 0
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "recommends", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "recommend_recipe", default: 0, null: false
    t.float "avg_staple", default: 0.0, null: false
    t.float "avg_main", default: 0.0, null: false
    t.float "avg_side", default: 0.0, null: false
    t.float "avg_country", default: 0.0, null: false
    t.integer "sum_staple", default: 0, null: false
    t.integer "sum_main", default: 0, null: false
    t.integer "sum_side", default: 0, null: false
    t.integer "sum_country", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_recommends_on_user_id"
  end

  create_table "sns_credentials", charset: "utf8mb4", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sns_credentials_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "characteristic", default: 0, null: false
    t.string "name", null: false
    t.text "introduction"
    t.string "profile_image"
    t.integer "level", default: 1, null: false
    t.integer "experience_point", default: 0, null: false
    t.integer "rest_point", default: 30, null: false
    t.text "url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "favorites", "recipes"
  add_foreign_key "favorites", "users"
  add_foreign_key "genres", "recipes"
  add_foreign_key "makes", "recipes"
  add_foreign_key "makes", "users"
  add_foreign_key "recipes", "users"
  add_foreign_key "recommends", "users"
  add_foreign_key "sns_credentials", "users"
end
