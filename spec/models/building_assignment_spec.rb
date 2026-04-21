require 'rails_helper'

RSpec.describe BuildingAssignment, type: :model do
  # --- TESTY ASOCIACÍ ---
  describe "Asociace" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:building) }
  end

  # --- TESTY VALIDACÍ ---
  describe "Validace" do
    # Vytvoříme si základní objekt pro test unikátnosti
    let(:user) { create(:user) }
    let(:building) { create(:building) }
    subject { BuildingAssignment.new(user: user, building: building) }

    it "je platný s uživatelem a budovou" do
      expect(subject).to be_valid
    end

    # Test unikátnosti: Jeden uživatel nesmí být u jedné budovy 2x
    it "nepovolí duplicitní přiřazení stejného uživatele ke stejné budově" do
      # První přiřazení uložíme
      create(:building_assignment, user: user, building: building)

      # Druhé stejné přiřazení by mělo být nevalidní
      duplicitni = BuildingAssignment.new(user: user, building: building)
      expect(duplicitni).not_to be_valid
    end
  end
end
