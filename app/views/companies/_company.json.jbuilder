json.extract! company, :id, :name, :symbol, :stockexchange_id, :sector_id, :created_at, :updated_at
json.url company_url(company, format: :json)