json.extract! reference_web, :id, :name, :url, :user_id, :created_at, :updated_at
json.url reference_web_url(reference_web, format: :json)