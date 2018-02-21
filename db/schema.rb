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

ActiveRecord::Schema.define(version: 20180204122305) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "account_number"
    t.string "description"
    t.string "iban"
    t.string "bic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hibiscus_account_id"
    t.bigint "item_id"
    t.index ["item_id"], name: "index_accounts_on_item_id"
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "finance_states", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "period"
    t.integer "hibiscus_sync_id"
    t.decimal "balance", precision: 8, scale: 2
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_finance_states_on_account_id"
  end

  create_table "hibiscus_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hibiscus_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "intervals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "numerator", precision: 8, scale: 2
    t.decimal "denominator", precision: 8, scale: 2
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "order_id"
    t.string "name"
    t.decimal "total_amount", precision: 8, scale: 2
    t.decimal "amount_calculated", precision: 8, scale: 2
    t.boolean "reserve"
    t.date "maturity"
    t.boolean "active"
    t.bigint "category_id"
    t.bigint "interval_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key_words"
    t.bigint "account_id"
    t.string "external_account"
    t.boolean "budget"
    t.bigint "savings_id"
    t.bigint "parent_id"
    t.index ["account_id"], name: "index_items_on_account_id"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["interval_id"], name: "index_items_on_interval_id"
    t.index ["parent_id"], name: "index_items_on_parent_id"
    t.index ["savings_id"], name: "index_items_on_savings_id"
  end

  create_table "monthly_statistics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "period"
    t.decimal "planned_value", precision: 8, scale: 2
    t.decimal "actual_value", precision: 8, scale: 2
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hibiscus_sync_id"
    t.decimal "match_confidence", precision: 8, scale: 2
    t.string "match_type"
    t.string "match_value"
    t.bigint "account_id"
    t.boolean "internal_transaction"
    t.boolean "reserve_payment"
    t.boolean "reserve_release"
    t.string "text"
    t.index ["account_id"], name: "index_monthly_statistics_on_account_id"
    t.index ["item_id"], name: "index_monthly_statistics_on_item_id"
  end

  create_table "navigations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "display_text"
    t.string "url"
    t.string "html_class"
    t.integer "parent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id"
  end

  create_table "savings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "items"
  add_foreign_key "finance_states", "accounts"
  add_foreign_key "items", "accounts"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "intervals"
  add_foreign_key "items", "savings", column: "savings_id"
  add_foreign_key "monthly_statistics", "accounts"
  add_foreign_key "monthly_statistics", "items"
end
