json.extract! company_historic_dividend, :id, :exdividend_date, :record_date, :announce_date, :payment_Date, :amount, :float, :dividend_type, :company_id, :user_id, :created_at, :updated_at
json.url company_historic_dividend_url(company_historic_dividend, format: :json)