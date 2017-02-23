json.extract! stockexchange, :id, :name, :country_id, :currency_id, :created_at, :updated_at
json.url stockexchange_url(stockexchange, format: :json)