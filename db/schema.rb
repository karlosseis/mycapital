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

ActiveRecord::Schema.define(version: 20170730221047) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "account_type_id", limit: 4
    t.integer  "bank_id",         limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "accounts", ["bank_id"], name: "index_accounts_on_bank_id", using: :btree
  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "balance_details", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.float    "amount",       limit: 24
    t.date     "balance_date"
    t.integer  "balance_id",   limit: 4
    t.integer  "account_id",   limit: 4
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "balance_details", ["account_id"], name: "index_balance_details_on_account_id", using: :btree
  add_index "balance_details", ["balance_id"], name: "index_balance_details_on_balance_id", using: :btree
  add_index "balance_details", ["user_id"], name: "index_balance_details_on_user_id", using: :btree

  create_table "balances", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.date     "balance_date"
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "details",       limit: 65535
    t.float    "total_sum",     limit: 24
    t.float    "cash_sum",      limit: 24
    t.float    "loan_sum",      limit: 24
    t.float    "portfolio_sum", limit: 24
  end

  add_index "balances", ["user_id"], name: "index_balances_on_user_id", using: :btree

  create_table "banks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "banks", ["user_id"], name: "index_banks_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",                                   limit: 255
    t.string   "symbol",                                 limit: 255
    t.integer  "stockexchange_id",                       limit: 4
    t.integer  "sector_id",                              limit: 4
    t.float    "share_price",                            limit: 24,    default: 0.0
    t.string   "search_symbol",                          limit: 255
    t.date     "date_share_price"
    t.float    "dividend_sum",                           limit: 24,    default: 0.0
    t.float    "puchased_sum",                           limit: 24,    default: 0.0
    t.float    "sold_sum",                               limit: 24,    default: 0.0
    t.float    "ampliated_sum",                          limit: 24,    default: 0.0
    t.float    "quantity_puchased",                      limit: 24,    default: 0.0
    t.float    "quantity_sold",                          limit: 24,    default: 0.0
    t.float    "quantity_ampliated",                     limit: 24,    default: 0.0
    t.float    "shares_sum",                             limit: 24,    default: 0.0
    t.float    "invested_sum",                           limit: 24,    default: 0.0
    t.float    "average_price",                          limit: 24,    default: 0.0
    t.float    "share_price_global_currency",            limit: 24,    default: 0.0
    t.float    "estimated_value_global_currency",        limit: 24,    default: 0.0
    t.float    "estimated_benefit_global_currency",      limit: 24,    default: 0.0
    t.float    "perc_estimated_benefit_global_currency", limit: 24,    default: 0.0
    t.float    "average_price_origin_currency",          limit: 24,    default: 0.0
    t.integer  "user_id",                                limit: 4
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.float    "average_price_real",                     limit: 24
    t.float    "average_price_origin_currency_real",     limit: 24
    t.float    "target_price_1",                         limit: 24,    default: 0.0
    t.float    "target_price_2",                         limit: 24,    default: 0.0
    t.integer  "traffic_light_id",                       limit: 4,     default: 0
    t.string   "investors_url",                          limit: 255
    t.float    "target_sell_price",                      limit: 24,    default: 0.0
    t.boolean  "dividend_aristocrat"
    t.text     "activity_description",                   limit: 65535
    t.integer  "first_uninterrupted_year_div",           limit: 4
    t.float    "shares_quantity",                        limit: 24,    default: 0.0
    t.float    "payout",                                 limit: 24,    default: 0.0
    t.integer  "dividend_payments_quantity",             limit: 4,     default: 0
    t.string   "historic_dividend_url",                  limit: 255
    t.float    "dividend_last_result",                   limit: 24
    t.date     "next_exdividend_date"
    t.date     "next_dividend_date"
    t.float    "next_dividend_amount",                   limit: 24
    t.float    "estimated_year_dividend_amount",         limit: 24
  end

  add_index "companies", ["sector_id"], name: "index_companies_on_sector_id", using: :btree
  add_index "companies", ["stockexchange_id"], name: "index_companies_on_stockexchange_id", using: :btree
  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "company_comments", force: :cascade do |t|
    t.text     "comment",      limit: 65535
    t.string   "url",          limit: 255
    t.integer  "company_id",   limit: 4
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.date     "date_comment"
  end

  add_index "company_comments", ["company_id"], name: "index_company_comments_on_company_id", using: :btree
  add_index "company_comments", ["user_id"], name: "index_company_comments_on_user_id", using: :btree

  create_table "company_historic_dividends", force: :cascade do |t|
    t.date     "exdividend_date"
    t.date     "record_date"
    t.date     "announce_date"
    t.integer  "dividend_type",   limit: 4,  default: 0
    t.integer  "company_id",      limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.date     "payment_date"
    t.float    "amount",          limit: 24
  end

  add_index "company_historic_dividends", ["company_id"], name: "index_company_historic_dividends_on_company_id", using: :btree
  add_index "company_historic_dividends", ["user_id"], name: "index_company_historic_dividends_on_user_id", using: :btree

  create_table "company_results", force: :cascade do |t|
    t.date     "fecha_resultado"
    t.boolean  "es_oficial"
    t.float    "cotizacion",               limit: 24,    default: 0.0
    t.float    "cotiz_max",                limit: 24,    default: 0.0
    t.float    "cotiz_min",                limit: 24,    default: 0.0
    t.float    "patrimonio_neto",          limit: 24,    default: 0.0
    t.float    "gastos_generales",         limit: 24,    default: 0.0
    t.float    "gastos_desarrollo",        limit: 24,    default: 0.0
    t.float    "ventas",                   limit: 24,    default: 0.0
    t.float    "ebitda",                   limit: 24,    default: 0.0
    t.float    "ebit",                     limit: 24,    default: 0.0
    t.float    "beneficio_neto_ordinario", limit: 24,    default: 0.0
    t.float    "beneficion_neto_total",    limit: 24,    default: 0.0
    t.float    "deuda_largo_plazo",        limit: 24,    default: 0.0
    t.float    "deuda_corto_plazo",        limit: 24,    default: 0.0
    t.float    "deuda_neta",               limit: 24,    default: 0.0
    t.float    "cf_explotacion",           limit: 24,    default: 0.0
    t.float    "cf_inversion",             limit: 24,    default: 0.0
    t.float    "cf_financiacion",          limit: 24,    default: 0.0
    t.float    "cf_neto",                  limit: 24,    default: 0.0
    t.float    "dividendo_ordinario",      limit: 24,    default: 0.0
    t.float    "dividendo_extraordinario", limit: 24,    default: 0.0
    t.float    "dividendo_total",          limit: 24,    default: 0.0
    t.float    "num_acciones",             limit: 24,    default: 0.0
    t.float    "bpa",                      limit: 24,    default: 0.0
    t.float    "payout",                   limit: 24,    default: 0.0
    t.float    "pago_dividendos",          limit: 24,    default: 0.0
    t.float    "per_max",                  limit: 24,    default: 0.0
    t.float    "per_med",                  limit: 24,    default: 0.0
    t.float    "per_min",                  limit: 24,    default: 0.0
    t.integer  "company_id",               limit: 4
    t.integer  "user_id",                  limit: 4
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.date     "year_result"
    t.text     "comment",                  limit: 65535
  end

  add_index "company_results", ["company_id"], name: "index_company_results_on_company_id", using: :btree
  add_index "company_results", ["user_id"], name: "index_company_results_on_user_id", using: :btree

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

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "estimated_movements", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.float    "amount",          limit: 24
    t.date     "movement_date"
    t.integer  "subcategory_id",  limit: 4
    t.integer  "movementtype_id", limit: 4
    t.integer  "account_id",      limit: 4
    t.integer  "month_number",    limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "account_name",    limit: 255
  end

  add_index "estimated_movements", ["account_id"], name: "index_estimated_movements_on_account_id", using: :btree
  add_index "estimated_movements", ["movementtype_id"], name: "index_estimated_movements_on_movementtype_id", using: :btree
  add_index "estimated_movements", ["subcategory_id"], name: "index_estimated_movements_on_subcategory_id", using: :btree
  add_index "estimated_movements", ["user_id"], name: "index_estimated_movements_on_user_id", using: :btree

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

  add_index "expected_dividends", ["company_id"], name: "index_expected_dividends_on_company_id", using: :btree
  add_index "expected_dividends", ["currency_id"], name: "index_expected_dividends_on_currency_id", using: :btree
  add_index "expected_dividends", ["operationtype_id"], name: "index_expected_dividends_on_operationtype_id", using: :btree
  add_index "expected_dividends", ["user_id"], name: "index_expected_dividends_on_user_id", using: :btree

  create_table "expert_target_prices", force: :cascade do |t|
    t.date     "date_target_price"
    t.float    "target_price_1",    limit: 24
    t.float    "target_price_2",    limit: 24
    t.string   "url",               limit: 255
    t.integer  "company_id",        limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id",           limit: 4
    t.integer  "reference_web_id",  limit: 4
  end

  add_index "expert_target_prices", ["company_id"], name: "index_expert_target_prices_on_company_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "name_long",  limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "locations", ["user_id"], name: "index_locations_on_user_id", using: :btree

  create_table "movements", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.float    "amount",          limit: 24
    t.date     "movement_date"
    t.integer  "subcategory_id",  limit: 4
    t.integer  "movementtype_id", limit: 4
    t.integer  "account_id",      limit: 4
    t.integer  "location_id",     limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "movements", ["account_id"], name: "index_movements_on_account_id", using: :btree
  add_index "movements", ["location_id"], name: "index_movements_on_location_id", using: :btree
  add_index "movements", ["movementtype_id"], name: "index_movements_on_movementtype_id", using: :btree
  add_index "movements", ["subcategory_id"], name: "index_movements_on_subcategory_id", using: :btree
  add_index "movements", ["user_id"], name: "index_movements_on_user_id", using: :btree

  create_table "movementtypes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "movementtypes", ["user_id"], name: "index_movementtypes_on_user_id", using: :btree

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

  add_index "operations", ["company_id"], name: "index_operations_on_company_id", using: :btree
  add_index "operations", ["currency_id"], name: "index_operations_on_currency_id", using: :btree
  add_index "operations", ["operationtype_id"], name: "index_operations_on_operationtype_id", using: :btree
  add_index "operations", ["user_id"], name: "index_operations_on_user_id", using: :btree

  create_table "operationtypes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "periodicities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "num_months", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "periodicities", ["user_id"], name: "index_periodicities_on_user_id", using: :btree

  create_table "planif_records", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.float    "amount",         limit: 24
    t.integer  "day",            limit: 4
    t.integer  "start_month",    limit: 4
    t.date     "start_at"
    t.date     "end_at"
    t.integer  "subcategory_id", limit: 4
    t.integer  "account_id",     limit: 4
    t.integer  "periodicity_id", limit: 4
    t.integer  "user_id",        limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "planif_records", ["account_id"], name: "index_planif_records_on_account_id", using: :btree
  add_index "planif_records", ["periodicity_id"], name: "index_planif_records_on_periodicity_id", using: :btree
  add_index "planif_records", ["subcategory_id"], name: "index_planif_records_on_subcategory_id", using: :btree
  add_index "planif_records", ["user_id"], name: "index_planif_records_on_user_id", using: :btree

  create_table "reference_webs", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "name",       limit: 255
  end

  add_index "reference_webs", ["user_id"], name: "index_reference_webs_on_user_id", using: :btree

  create_table "sectors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "stockexchanges", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "country_id",    limit: 4
    t.integer  "currency_id",   limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "google_prefix", limit: 255
    t.string   "yahoo_suffix",  limit: 255
  end

  add_index "stockexchanges", ["country_id"], name: "index_stockexchanges_on_country_id", using: :btree
  add_index "stockexchanges", ["currency_id"], name: "index_stockexchanges_on_currency_id", using: :btree

  create_table "subcategories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "category_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "subcategories", ["category_id"], name: "index_subcategories_on_category_id", using: :btree
  add_index "subcategories", ["user_id"], name: "index_subcategories_on_user_id", using: :btree

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
    t.integer  "permission_level",       limit: 4,   default: 1
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "yahoo_tickers", force: :cascade do |t|
    t.string   "ticker",       limit: 255
    t.string   "name",         limit: 255
    t.string   "exchange",     limit: 255
    t.string   "name_country", limit: 255
    t.string   "category",     limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_foreign_key "accounts", "banks"
  add_foreign_key "accounts", "users"
  add_foreign_key "balance_details", "accounts"
  add_foreign_key "balance_details", "balances"
  add_foreign_key "balance_details", "users"
  add_foreign_key "balances", "users"
  add_foreign_key "banks", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "companies", "sectors"
  add_foreign_key "companies", "stockexchanges"
  add_foreign_key "companies", "users"
  add_foreign_key "company_comments", "companies"
  add_foreign_key "company_comments", "users"
  add_foreign_key "company_historic_dividends", "companies"
  add_foreign_key "company_historic_dividends", "users"
  add_foreign_key "company_results", "companies"
  add_foreign_key "company_results", "users"
  add_foreign_key "estimated_movements", "accounts"
  add_foreign_key "estimated_movements", "movementtypes"
  add_foreign_key "estimated_movements", "subcategories"
  add_foreign_key "estimated_movements", "users"
  add_foreign_key "expected_dividends", "companies"
  add_foreign_key "expected_dividends", "currencies"
  add_foreign_key "expected_dividends", "operationtypes"
  add_foreign_key "expected_dividends", "users"
  add_foreign_key "expert_target_prices", "companies"
  add_foreign_key "locations", "users"
  add_foreign_key "movements", "accounts"
  add_foreign_key "movements", "locations"
  add_foreign_key "movements", "movementtypes"
  add_foreign_key "movements", "subcategories"
  add_foreign_key "movements", "users"
  add_foreign_key "movementtypes", "users"
  add_foreign_key "operations", "companies"
  add_foreign_key "operations", "currencies"
  add_foreign_key "operations", "operationtypes"
  add_foreign_key "operations", "users"
  add_foreign_key "periodicities", "users"
  add_foreign_key "planif_records", "accounts"
  add_foreign_key "planif_records", "periodicities"
  add_foreign_key "planif_records", "subcategories"
  add_foreign_key "planif_records", "users"
  add_foreign_key "reference_webs", "users"
  add_foreign_key "stockexchanges", "countries"
  add_foreign_key "stockexchanges", "currencies"
  add_foreign_key "subcategories", "categories"
  add_foreign_key "subcategories", "users"
end
