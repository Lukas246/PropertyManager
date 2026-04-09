require 'rails_helper'

RSpec.describe "Api::V1::Assets", type: :request do
  # Využití FactoryBot místo přímého volání .create!
  let!(:user) { create(:user, role: "admin") }

  # Factory pro budovu a místnost (s přepisem konkrétních hodnot, pokud je v testu potřebujeme)
  let!(:building) { create(:building, name: "Budova A", code: "A1") }
  let!(:room) { create(:room, name: "Kancl", code: "101", building: building) }

  # Factory pro samotný majetek
  let!(:asset) { create(:asset, name: "Starý stůl", code: "ST-01", room: room) }

  describe "GET /api/v1/inventory" do
    it "vrátí seznam majetku" do
      get "/api/v1/inventory", headers: { "X-Api-Key" => user.api_key }

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/v1/inventory" do
    it "vytvoří nový majetek" do
      params = {
        asset: {
          name: "Test PC",
          code: "PC-01",
          room_id: room.id,
          purchase_date: Date.today,
          last_inspection_date: Date.today
        }
      }

      post "/api/v1/inventory",
           params: params.to_json,
           headers: { "X-Api-Key" => user.api_key, "Content-Type" => "application/json" }

      expect(response).to have_http_status(:created)
      expect(Asset.last.name).to eq("Test PC")
    end
  end

  # Přidání `versioning: true` zajistí, že PaperTrail bude pro tento blok aktivní
  describe "GET /api/v1/inventory/:id/audit_log", versioning: true do
    before do
      # Simulace: Řekneme PaperTrailu, který uživatel provádí následující akci
      PaperTrail.request.whodunnit = user.id

      # Provedeme změnu, aby se vytvořil záznam v historii
      asset.update!(name: "Nový stůl")
    end

    it "vrátí historii změn daného majetku ve formátu JSON" do
      get "/api/v1/inventory/#{asset.id}/audit_log", headers: { "X-Api-Key" => user.api_key }

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)

      expect(json).not_to be_empty
      last_version = json.last

      # Ověření struktury vráceného JSONu podle naší služby
      expect(last_version["event"]).to eq("update")
      expect(last_version["changes"]["name"]).to eq(["Starý stůl", "Nový stůl"])
      expect(last_version["whodunnit"]).to eq(user.email)
    end
  end
end
