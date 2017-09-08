json.extract! yahoo_ticker, :id, :ticker, :name, :exchange, :name_country, :category, :created_at, :updated_at
json.url yahoo_ticker_url(yahoo_ticker, format: :json)