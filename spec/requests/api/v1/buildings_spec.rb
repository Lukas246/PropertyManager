require 'rails_helper'

RSpec.describe "Api::V1::Buildings", type: :request do
  let!(:user) { create(:user, role: 'admin') }
  let!(:building) { create(:building, name: "Centrála Ostrava", code: "CO-01") }

  let(:headers) { { "X-Api-Key" => user.api_key, "Accept" => "application/json" } }

  describe "GET /api/v1/buildings" do
    it "vrátí seznam budov pro autorizovaného uživatele" do
      get "/api/v1/buildings", headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.first["name"]).to eq("Centrála Ostrava")
      expect(json.first["code"]).to eq("CO-01")
    end

    it "vrátí 401 Unauthorized při nesprávném API klíči" do
      get "/api/v1/buildings", headers: { "X-Api-Key" => "neplatny-klic" }

      expect(response).to have_http_status(:unauthorized)
    end

    it "využívá cache (nevolá DB při druhém požadavku)", :caching do
      # První volání naplní Redis
      get "/api/v1/buildings", headers: headers

      # Při druhém volání nesmí proběhnout SQL dotaz na budovy
      expect(Building).not_to receive(:accessible_by)
      get "/api/v1/buildings", headers: headers
    end
  end
end
