json.extract! company_comment, :id, :comment, :url, :company_id, :user_id, :created_at, :updated_at
json.url company_comment_url(company_comment, format: :json)