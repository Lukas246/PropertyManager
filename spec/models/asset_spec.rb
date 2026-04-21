require 'rails_helper'

RSpec.describe Asset, type: :model do
  # --- PŘÍPRAVA DAT (let definujeme pro celý soubor) ---
  let(:building) do
    Building.create!(
      name: "Test Budova",
      code: "B1",
      contact_person_email: "test@test.cz",
      contact_person_phone: "123456789",
      building_created_at: Time.current
    )
  end

  let(:room) do
    Room.create!(
      name: "Test Room",
      code: "R01",
      room_created_at: Time.current,
      building: building
    )
  end

  # --- TESTY VALIDACÍ ---
  describe "Validace" do
    it "je platný s vyplněnými povinnými údaji" do
      asset = Asset.new(
        name: "Testovací majetek",
        code: "INV001",
        purchase_date: Date.today,
        last_inspection_date: Date.today,
        purchase_price: 1000,
        room: room
      )
      expect(asset).to be_valid
    end

    # Jednořádkové matchery (Shoulda Matchers)
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:purchase_date) }
    it { is_expected.to validate_presence_of(:last_inspection_date) }

    it "vyžaduje nezápornou cenu nákupu" do
      asset = Asset.new(purchase_price: -100)
      asset.valid?
      expect(asset.errors[:purchase_price]).to include("must be greater than or equal to 0")
    end
  end

  # --- TESTY ASOCIACÍ ---
  describe "Asociace" do
    it { is_expected.to belong_to(:room) }

    it "má povinnou vazbu na místnost" do
      association = described_class.reflect_on_association(:room)
      expect(association.options[:optional]).to be_falsy
    end
  end

  # --- TESTY NOVÝCH FUNKCÍ ---
  describe "Nové funkce" do
    # Test pro Active Storage (musí být samostatně)
    it { is_expected.to have_many_attached(:attachments) }

    it "sleduje historii změn (PaperTrail)" do
      # Používáme room s budovou, aby validace prošla
      asset = Asset.create!(
        name: "Původní název",
        code: "A1",
        purchase_date: Date.today,
        last_inspection_date: Date.today,
        room: room
      )

      expect {
        asset.update!(name: "Nový název")
      }.to change { asset.versions.count }.by(1)
    end
  end
end
