json.extract! user, :id, :full_name, :role, :email, :phone, :member_code, :created_at, :updated_at
json.url user_url(user, format: :json)
