require 'rails_helper'

RSpec.describe CsvExportJob, type: :job do
  let(:user) { create(:user, role: 'admin') }
  let(:room) { create(:room) }
  let!(:asset_1) { create(:asset, name: "Monitor", purchase_price: 5000, room: room) }
  let!(:asset_2) { create(:asset, name: "Stůl", purchase_price: 2000, room: room) }

  describe "#perform" do
    it "vyfiltruje data a předá je maileru" do
      filters = { 'price_from' => 4000 } # Měl by projít jen Monitor

      # Testujeme, že Mailer obdrží string, který obsahuje 'Monitor' a neobsahuje 'Stůl'
      expect(ExportMailer).to receive(:send_csv) do |u, csv_string|
        expect(u).to eq(user)
        expect(csv_string).to include("Monitor")
        expect(csv_string).not_to include("Stůl")
        double(deliver_now: true)
      end

      CsvExportJob.perform_now(user.id, filters)
    end

    it "respektuje oprávnění správce (BuildingAssignment)" do
      spravce = create(:user, role: 'spravce')
      jina_budova = create(:building)
      jiny_pokoj = create(:room, building: jina_budova)
      create(:asset, name: "Cizí věc", room: jiny_pokoj)

      # Správce nemá k cizí budově přístup
      expect(ExportMailer).to receive(:send_csv) do |_, csv_string|
        expect(csv_string).not_to include("Cizí věc")
        double(deliver_now: true)
      end

      CsvExportJob.perform_now(spravce.id, {})
    end
  end
end