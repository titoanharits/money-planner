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

ActiveRecord::Schema[8.1].define(version: 2026_06_05_091657) do
  create_table "balance_adjustments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.datetime "created_at", null: false
    t.decimal "new_balance", precision: 15, scale: 2, null: false
    t.string "note"
    t.bigint "pocket_id", null: false
    t.decimal "previous_balance", precision: 15, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["pocket_id"], name: "index_balance_adjustments_on_pocket_id"
    t.index ["user_id"], name: "index_balance_adjustments_on_user_id"
  end

  create_table "budgets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.integer "month"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "year"
    t.index ["category_id"], name: "index_budgets_on_category_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "category_type"
    t.string "color"
    t.datetime "created_at", null: false
    t.string "icon"
    t.json "metadata"
    t.string "name"
    t.boolean "system_default", default: false, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "pockets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.string "icon"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_pockets_on_user_id"
  end

  create_table "transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "amount", precision: 10
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.date "date"
    t.string "description"
    t.bigint "destination_pocket_id"
    t.bigint "source_pocket_id"
    t.time "time"
    t.integer "transaction_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["destination_pocket_id"], name: "index_transactions_on_destination_pocket_id"
    t.index ["source_pocket_id"], name: "index_transactions_on_source_pocket_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "billing_start_day", default: 1, null: false
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "balance_adjustments", "pockets"
  add_foreign_key "balance_adjustments", "users"
  add_foreign_key "budgets", "categories"
  add_foreign_key "budgets", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "pockets", "users"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "pockets", column: "destination_pocket_id"
  add_foreign_key "transactions", "pockets", column: "source_pocket_id"
  add_foreign_key "transactions", "users"
end
