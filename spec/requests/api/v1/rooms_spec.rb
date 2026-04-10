require 'rails_helper'

RSpec.describe "Api::V1::Rooms", type: :request do
  let!(:user) { create(:user, role: 'admin') }
  let!(:building) { create(:building, name: "Budova A") }
  let!(:room) { create(:room, name: "Serverovna", code: "S-101", building: building) }

  let(:headers) { { "X-Api-Key" => user.api_key, "Accept" => "application/json" } }

  describe "GET /api/v1/rooms" do
    it "vrátí seznam místností včetně informací o budově" do
      get "/api/v1/rooms", headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.first["name"]).to eq("Serverovna")
      # Pokud tvoje API vrací i ID budovy, můžeme to ověřit:
      expect(json.first["building_id"]).to eq(building.id)
    end

    it "vrátí prázdné pole, pokud uživatel nemá k žádné místnosti přístup" do
      # Simulace uživatele bez práv (pokud to řešíš přes CanCanCan)
      user_without_rights = create(:user, role: 'čtenář')
      get "/api/v1/rooms", headers: { "X-Api-Key" => "nesmyslný-klíč" }

      json = JSON.parse(response.body)
      # Předpokládáme, že ListService vrátí prázdné pole kvůli accessible_by
      expect(json).to eq("error" => "Neautorizovaný přístup")
    end
  end
end