json.extract! asset, :id, :name, :code, :room_id, :purchase_date, :last_inspection_date, :note, :purchase_price, :created_at, :updated_at
json.url asset_url(asset, format: :json)
