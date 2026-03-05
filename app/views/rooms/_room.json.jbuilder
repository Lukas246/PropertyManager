json.extract! room, :id, :name, :code, :building_id, :room_created_at, :created_at, :updated_at
json.url room_url(room, format: :json)
