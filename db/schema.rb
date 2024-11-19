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

ActiveRecord::Schema[7.0].define(version: 2024_11_18_122734) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stock_shares", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "stock_id", null: false
    t.integer "shares"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_shares_on_stock_id"
    t.index ["user_id"], name: "index_stock_shares_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "symbol"
    t.string "name"
    t.decimal "last_price"
    t.decimal "day_high"
    t.decimal "day_low"
    t.decimal "year_high"
    t.decimal "year_low"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaction_logs", force: :cascade do |t|
    t.bigint "wallet_id", null: false
    t.string "transaction_type"
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "source_wallet_id"
    t.bigint "target_wallet_id"
    t.index ["source_wallet_id"], name: "index_transaction_logs_on_source_wallet_id"
    t.index ["target_wallet_id"], name: "index_transaction_logs_on_target_wallet_id"
    t.index ["wallet_id"], name: "index_transaction_logs_on_wallet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.string "password_digest"
    t.string "token"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.decimal "balance", precision: 15, scale: 2, default: "0.0", null: false
    t.string "walletable_type", null: false
    t.bigint "walletable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lock_version", default: 0, null: false
    t.index ["walletable_type", "walletable_id"], name: "index_wallets_on_walletable"
    t.check_constraint "balance >= 0::numeric", name: "balance_non_negative"
  end

  add_foreign_key "stock_shares", "stocks"
  add_foreign_key "stock_shares", "users"
  add_foreign_key "transaction_logs", "wallets"
  add_foreign_key "transaction_logs", "wallets", column: "source_wallet_id"
  add_foreign_key "transaction_logs", "wallets", column: "target_wallet_id"
  add_foreign_key "users", "teams"
end
