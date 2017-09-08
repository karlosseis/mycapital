json.extract! balance_detail, :id, :name, :amount, :balance_date, :balance_id, :account_id, :user_id, :created_at, :updated_at
json.url balance_detail_url(balance_detail, format: :json)