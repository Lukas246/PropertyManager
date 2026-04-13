require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validace" do
    it "je validní s kompletními údaji z továrny" do
      expect(build(:user)).to be_valid
    end

    it "vyžaduje roli" do
      user = build(:user, role: nil)
      expect(user).not_to be_valid
    end

    it "vyžaduje kód člena" do
      user = build(:user, member_code: nil)
      expect(user).not_to be_valid
    end

    it "vyžaduje unikátní e-mail" do
      # Vytvoříme prvního uživatele v DB
      create(:user, email: "jan@test.cz")

      # Zkusíme vytvořit druhého se stejným mailem
      duplicate = build(:user, email: "jan@test.cz")

      expect(duplicate).not_to be_valid
    end
  end

  describe "ransack" do
    it "povoluje vyhledávání podle správných atributů" do
      expect(User.ransackable_attributes).to include("member_code", "full_name")
    end
  end
end