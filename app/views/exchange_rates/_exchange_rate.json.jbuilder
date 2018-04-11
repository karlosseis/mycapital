json.extract! exchange_rate, :id, :date_exchange, :pair, :rate, :created_at, :updated_at
json.url exchange_rate_url(exchange_rate, format: :json)
