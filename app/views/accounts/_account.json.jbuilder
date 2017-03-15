json.extract! account, :id, :name, :account_type_id, :bank_id, :user_id, :created_at, :updated_at
json.url account_url(account, format: :json)