# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170223175119) do

  create_table "companies", force: :cascade do |t|
    t.string   "name",                                   limit: 255
    t.string   "symbol",                                 limit: 255
    t.integer  "stockexchange_id",                       limit: 4
    t.integer  "sector_id",                              limit: 4
    t.float    "share_price",                            limit: 24,  default: 0.0
    t.string   "search_symbol",                          limit: 255
    t.date     "date_share_price"
    t.float    "dividend_sum",                           limit: 24,  default: 0.0
    t.float    "puchased_sum",                           limit: 24,  default: 0.0
    t.float    "sold_sum",                               limit: 24,  default: 0.0
    t.float    "ampliated_sum",                          limit: 24,  default: 0.0
    t.float    "quantity_puchased",                      limit: 24,  default: 0.0
    t.float    "quantity_sold",                          limit: 24,  default: 0.0
    t.float    "quantity_ampliated",                     limit: 24,  default: 0.0
    t.float    "shares_sum",                             limit: 24,  default: 0.0
    t.float    "invested_sum",                           limit: 24,  default: 0.0
    t.float    "average_price",                          limit: 24,  default: 0.0
    t.float    "share_price_global_currency",            limit: 24,  default: 0.0
    t.float    "estimated_value_global_currency",        limit: 24,  default: 0.0
    t.float    "estimated_benefit_global_currency",      limit: 24,  default: 0.0
    t.float    "perc_estimated_benefit_global_currency", limit: 24,  default: 0.0
    t.float    "average_price_origin_currency",          limit: 24,  default: 0.0
    t.integer  "user_id",                                limit: 4
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "companies", ["sector_id"], name: "index_companies_on_sector_id"
  add_index "companies", ["stockexchange_id"], name: "index_companies_on_stockexchange_id"
  add_index "companies", ["user_id"], name: "index_companies_on_user_id"

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "symbol",     limit: 255
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "expected_dividends", force: :cascade do |t|
    t.integer  "company_id",        limit: 4
    t.integer  "operationtype_id",  limit: 4
    t.date     "operation_date"
    t.integer  "quantity",          limit: 4
    t.float    "price_unit",        limit: 24
    t.float    "amount",            limit: 24
    t.integer  "currency_id",       limit: 4
    t.float    "origin_price",      limit: 24
    t.float    "origin_price_unit", limit: 24
    t.float    "origin_amount",     limit: 24
    t.integer  "user_id",           limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "expected_dividends", ["company_id"], name: "index_expected_dividends_on_company_id"
  add_index "expected_dividends", ["currency_id"], name: "index_expected_dividends_on_currency_id"
  add_index "expected_dividends", ["operationtype_id"], name: "index_expected_dividends_on_operationtype_id"
  add_index "expected_dividends", ["user_id"], name: "index_expected_dividends_on_user_id"

  create_table "operations", force: :cascade do |t|
    t.integer  "company_id",       limit: 4
    t.integer  "operationtype_id", limit: 4
    t.float    "amount",           limit: 24
    t.text     "comments",         limit: 65535
    t.float    "commission",       limit: 24
    t.integer  "currency_id",      limit: 4
    t.float    "destination_tax",  limit: 24
    t.float    "exchange_rate",    limit: 24
    t.float    "fee",              limit: 24
    t.float    "gross_amount",     limit: 24
    t.float    "net_amount",       limit: 24
    t.date     "operation_date"
    t.float    "origin_price",     limit: 24
    t.float    "price",            limit: 24
    t.integer  "quantity",         limit: 4
    t.float    "withholding_tax",  limit: 24
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "operations", ["company_id"], name: "index_operations_on_company_id"
  add_index "operations", ["currency_id"], name: "index_operations_on_currency_id"
  add_index "operations", ["operationtype_id"], name: "index_operations_on_operationtype_id"
  add_index "operations", ["user_id"], name: "index_operations_on_user_id"

  create_table "operationtypes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "stockexchanges", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "country_id",  limit: 4
    t.integer  "currency_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "stockexchanges", ["country_id"], name: "index_stockexchanges_on_country_id"
  add_index "stockexchanges", ["currency_id"], name: "index_stockexchanges_on_currency_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.integer  "permission_level",       limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "yahoo_tickers", force: :cascade do |t|
    t.string   "ticker",       limit: 255
    t.string   "name",         limit: 255
    t.string   "exchange",     limit: 255
    t.string   "name_country", limit: 255
    t.string   "category",     limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
