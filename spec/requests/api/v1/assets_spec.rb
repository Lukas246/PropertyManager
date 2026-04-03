require 'rails_helper'

RSpec.describe "Api::V1::Assets", type: :request do
  let!(:user) { User.create!(full_name: "Admin", email: "a@b.cz", password: "abcdefg", role: "admin", member_code: "123") }
  let!(:building) { Building.create!(name: "Budova A", code: "A1", contact_person_email: "a@b.cz", contact_person_phone: "123", building_created_at: Date.today) }
  let!(:room) { Room.create!(name: "Kancl", code: "101", building: building, room_created_at: Date.today) }

  describe "GET /api/v1/inventory" do
    it "vrátí seznam majetku" do
      get "/api/v1/inventory", headers: { "X-Api-Key" => user.api_key }
      expect(response).to have_http_status(:success)
    end
  end

  it "vrátí seznam majetku se správným klíčem" do
    get "/api/v1/inventory", headers: { "X-Api-Key" => user.api_key }
    expect(response).to have_http_status(:success)
  end

  describe "POST /api/v1/inventory" do
    it "vytvoří nový majetek" do
      params = { asset: { name: "Test PC", code: "PC-01", room_id: room.id, purchase_date: Date.today, last_inspection_date: Date.today } }
      post "/api/v1/inventory", params: params.to_json, headers: { "X-Api-Key" => user.api_key, "Content-Type" => "application/json" }

      expect(response).to have_http_status(:created)
      expect(Asset.last.name).to eq("Test PC")
    end
  end
end
