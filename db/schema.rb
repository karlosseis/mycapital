# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_22_115135) do

  create_table "accounts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.integer "account_type_id"
    t.integer "bank_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_id"], name: "index_accounts_on_bank_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "balance_details", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.float "amount", limit: 53
    t.date "balance_date"
    t.integer "balance_id"
    t.integer "account_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_balance_details_on_account_id"
    t.index ["balance_id"], name: "index_balance_details_on_balance_id"
    t.index ["user_id"], name: "index_balance_details_on_user_id"
  end

  create_table "balances", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.date "balance_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "details", size: :long
    t.float "total_sum", limit: 53
    t.float "cash_sum", limit: 53
    t.float "loan_sum", limit: 53
    t.float "portfolio_sum", limit: 53
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "banks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_banks_on_user_id"
  end

  create_table "brokers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.integer "buy_frequency"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "only_euros", limit: 1, default: 1
    t.index ["user_id"], name: "index_brokers_on_user_id"
  end

  create_table "categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "companies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.integer "stockexchange_id"
    t.integer "sector_id"
    t.float "share_price", default: 0.0
    t.string "search_symbol"
    t.datetime "date_share_price"
    t.float "dividend_sum", default: 0.0
    t.float "puchased_sum", default: 0.0
    t.float "sold_sum", default: 0.0
    t.float "ampliated_sum", default: 0.0
    t.float "quantity_puchased", default: 0.0
    t.float "quantity_sold", default: 0.0
    t.float "quantity_ampliated", default: 0.0
    t.float "shares_sum", default: 0.0
    t.float "invested_sum", default: 0.0
    t.float "average_price", default: 0.0
    t.float "share_price_global_currency", default: 0.0
    t.float "average_price_origin_currency", default: 0.0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "average_price_real", limit: 53
    t.float "average_price_origin_currency_real", limit: 53
    t.float "target_price_1", limit: 53, default: 0.0
    t.float "target_price_2", limit: 53, default: 0.0
    t.integer "traffic_light_id", default: 0
    t.text "investors_url", size: :long
    t.float "target_sell_price", limit: 53, default: 0.0
    t.integer "dividend_aristocrat", limit: 1
    t.text "activity_description", size: :long
    t.integer "first_uninterrupted_year_div"
    t.float "shares_quantity", limit: 53, default: 0.0
    t.float "payout", limit: 53, default: 0.0
    t.integer "dividend_payments_quantity", default: 0
    t.text "historic_dividend_url", size: :long
    t.float "dividend_last_result", limit: 53
    t.date "next_exdividend_date"
    t.date "next_dividend_date"
    t.float "next_dividend_amount", limit: 53
    t.float "estimated_year_dividend_amount", limit: 53
    t.string "currency_symbol_operations", default: ""
    t.float "estimated_value_operations_currency", limit: 53
    t.float "estimated_benefit_operations_currency", limit: 53
    t.float "perc_estimated_benefit_operations_currency", limit: 53, default: 0.0
    t.integer "broker_id"
    t.float "puchased_sum_euros", default: 0.0
    t.float "estimated_benefit_operations_currency_euros", default: 0.0
    t.float "perc_estimated_benefit_operations_currency_euros", default: 0.0
    t.date "nearest_announce_date"
    t.float "share_price_change_perc", default: 0.0
    t.float "share_price_change", default: 0.0
    t.integer "country_id"
    t.float "invested_sum_euros", default: 0.0
    t.float "earnings_sum", default: 0.0
    t.float "earnings_sum_euros", default: 0.0
    t.string "logo_url", default: ""
    t.index ["broker_id"], name: "index_companies_on_broker_id"
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["sector_id"], name: "index_companies_on_sector_id"
    t.index ["stockexchange_id"], name: "index_companies_on_stockexchange_id"
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "company_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "comment", size: :long
    t.text "url", size: :long
    t.integer "company_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_comment"
    t.index ["company_id"], name: "index_company_comments_on_company_id"
    t.index ["user_id"], name: "index_company_comments_on_user_id"
  end

  create_table "company_historic_dividends", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "exdividend_date"
    t.date "record_date"
    t.date "announce_date"
    t.integer "dividend_type", default: 0
    t.integer "company_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "payment_date"
    t.float "amount", limit: 53
    t.boolean "retrieved_auto", default: false
    t.index ["company_id"], name: "index_company_historic_dividends_on_company_id"
    t.index ["user_id"], name: "index_company_historic_dividends_on_user_id"
  end

  create_table "company_results", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "fecha_resultado"
    t.integer "es_oficial", limit: 1
    t.float "cotizacion", limit: 53, default: 0.0
    t.float "cotiz_max", limit: 53, default: 0.0
    t.float "cotiz_min", limit: 53, default: 0.0
    t.float "patrimonio_neto", limit: 53, default: 0.0
    t.float "gastos_generales", limit: 53, default: 0.0
    t.float "gastos_desarrollo", limit: 53, default: 0.0
    t.float "ventas", limit: 53, default: 0.0
    t.float "ebitda", limit: 53, default: 0.0
    t.float "ebit", limit: 53, default: 0.0
    t.float "beneficio_neto_ordinario", limit: 53, default: 0.0
    t.float "beneficion_neto_total", limit: 53, default: 0.0
    t.float "deuda_largo_plazo", limit: 53, default: 0.0
    t.float "deuda_corto_plazo", limit: 53, default: 0.0
    t.float "deuda_neta", limit: 53, default: 0.0
    t.float "cf_explotacion", limit: 53, default: 0.0
    t.float "cf_inversion", limit: 53, default: 0.0
    t.float "cf_financiacion", limit: 53, default: 0.0
    t.float "cf_neto", limit: 53, default: 0.0
    t.float "dividendo_ordinario", limit: 53, default: 0.0
    t.float "dividendo_extraordinario", limit: 53, default: 0.0
    t.float "dividendo_total", limit: 53, default: 0.0
    t.float "num_acciones", limit: 53, default: 0.0
    t.float "bpa", limit: 53, default: 0.0
    t.float "payout", limit: 53, default: 0.0
    t.float "pago_dividendos", limit: 53, default: 0.0
    t.float "per_max", limit: 53, default: 0.0
    t.float "per_med", limit: 53, default: 0.0
    t.float "per_min", limit: 53, default: 0.0
    t.integer "company_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "year_result"
    t.text "comment", size: :long
    t.index ["company_id"], name: "index_company_results_on_company_id"
    t.index ["user_id"], name: "index_company_results_on_user_id"
  end

  create_table "countries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "perc_tax", default: 0.0
  end

  create_table "currencies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "symbol"
  end

  create_table "delayed_jobs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", size: :long, null: false
    t.text "last_error", size: :long
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "estimated_movements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.float "amount", limit: 53
    t.date "movement_date"
    t.integer "subcategory_id"
    t.integer "movementtype_id"
    t.integer "account_id"
    t.integer "month_number"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "account_name", size: :long
    t.index ["account_id"], name: "index_estimated_movements_on_account_id"
    t.index ["movementtype_id"], name: "index_estimated_movements_on_movementtype_id"
    t.index ["subcategory_id"], name: "index_estimated_movements_on_subcategory_id"
    t.index ["user_id"], name: "index_estimated_movements_on_user_id"
  end

  create_table "exchange_rates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.date "date_exchange"
    t.string "pair"
    t.float "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expected_dividends", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "company_id"
    t.integer "operationtype_id"
    t.date "operation_date"
    t.integer "quantity"
    t.float "price_unit"
    t.float "amount"
    t.integer "currency_id"
    t.float "origin_price"
    t.float "origin_price_unit"
    t.float "origin_amount"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_expected_dividends_on_company_id"
    t.index ["currency_id"], name: "index_expected_dividends_on_currency_id"
    t.index ["operationtype_id"], name: "index_expected_dividends_on_operationtype_id"
    t.index ["user_id"], name: "index_expected_dividends_on_user_id"
  end

  create_table "expert_target_prices", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "date_target_price"
    t.float "target_price_1", limit: 53
    t.float "target_price_2", limit: 53
    t.text "url", size: :long
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "reference_web_id"
    t.index ["company_id"], name: "index_expert_target_prices_on_company_id"
  end

  create_table "export_empresas", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "ID"
    t.text "NAME"
  end

  create_table "export_empresas_dev", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "ID"
    t.text "NAME"
  end

  create_table "locations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.text "name_long", size: :long
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "mapconcepts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.integer "subcategory_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subcategory_id"], name: "index_mapconcepts_on_subcategory_id"
    t.index ["user_id"], name: "index_mapconcepts_on_user_id"
  end

  create_table "movements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.float "amount", limit: 53
    t.date "movement_date"
    t.integer "subcategory_id"
    t.integer "movementtype_id"
    t.integer "account_id"
    t.integer "location_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_movements_on_account_id"
    t.index ["location_id"], name: "index_movements_on_location_id"
    t.index ["movementtype_id"], name: "index_movements_on_movementtype_id"
    t.index ["subcategory_id"], name: "index_movements_on_subcategory_id"
    t.index ["user_id"], name: "index_movements_on_user_id"
  end

  create_table "movementtypes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_movementtypes_on_user_id"
  end

  create_table "operations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "company_id"
    t.integer "operationtype_id"
    t.float "amount"
    t.text "comments", size: :long
    t.float "commission"
    t.integer "currency_id"
    t.float "destination_tax"
    t.float "exchange_rate"
    t.float "fee"
    t.float "gross_amount"
    t.float "net_amount"
    t.date "operation_date"
    t.float "origin_price"
    t.float "price"
    t.integer "quantity"
    t.float "withholding_tax"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "broker_id", default: 1
    t.integer "currency_operation_id", default: 1
    t.float "puchased_sum_euros", default: 0.0
    t.float "tax_rate_auto", default: 0.0
    t.float "earnings_sum", default: 0.0
    t.float "earnings_sum_euros", default: 0.0
    t.index ["broker_id"], name: "index_operations_on_broker_id"
    t.index ["company_id"], name: "index_operations_on_company_id"
    t.index ["currency_id"], name: "index_operations_on_currency_id"
    t.index ["operationtype_id"], name: "index_operations_on_operationtype_id"
    t.index ["user_id"], name: "index_operations_on_user_id"
  end

  create_table "operationtypes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "periodicities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.integer "num_months"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_periodicities_on_user_id"
  end

  create_table "planif_records", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.float "amount", limit: 53
    t.integer "day"
    t.integer "start_month"
    t.date "start_at"
    t.date "end_at"
    t.integer "subcategory_id"
    t.integer "account_id"
    t.integer "periodicity_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_planif_records_on_account_id"
    t.index ["periodicity_id"], name: "index_planif_records_on_periodicity_id"
    t.index ["subcategory_id"], name: "index_planif_records_on_subcategory_id"
    t.index ["user_id"], name: "index_planif_records_on_user_id"
  end

  create_table "reference_webs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "url", size: :long
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "name", size: :long
    t.index ["user_id"], name: "index_reference_webs_on_user_id"
  end

  create_table "sectors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stockexchanges", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "country_id"
    t.integer "currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "google_prefix", size: :long
    t.text "yahoo_suffix", size: :long
    t.time "open_time"
    t.time "close_time"
    t.index ["country_id"], name: "index_stockexchanges_on_country_id"
    t.index ["currency_id"], name: "index_stockexchanges_on_currency_id"
  end

  create_table "subcategories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", size: :long
    t.integer "category_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
    t.index ["user_id"], name: "index_subcategories_on_user_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
    t.string "first_name"
    t.string "last_name"
    t.integer "permission_level", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "yahoo_tickers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "ticker"
    t.string "name"
    t.string "exchange"
    t.string "name_country"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "accounts", "banks"
  add_foreign_key "accounts", "users"
  add_foreign_key "balance_details", "accounts"
  add_foreign_key "balance_details", "balances"
  add_foreign_key "balance_details", "users"
  add_foreign_key "balances", "users"
  add_foreign_key "banks", "users"
  add_foreign_key "brokers", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "companies", "brokers"
  add_foreign_key "companies", "countries"
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
  add_foreign_key "mapconcepts", "subcategories"
  add_foreign_key "mapconcepts", "users"
  add_foreign_key "movements", "accounts"
  add_foreign_key "movements", "locations"
  add_foreign_key "movements", "movementtypes"
  add_foreign_key "movements", "subcategories"
  add_foreign_key "movements", "users"
  add_foreign_key "movementtypes", "users"
  add_foreign_key "operations", "brokers"
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
