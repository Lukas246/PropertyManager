require 'rails_helper'

RSpec.describe Buildings::ListService do
  let(:user) { create(:user, role: 'admin') }
  let(:ability) { Ability.new(user) } # Předpokládáme CanCanCan
  let!(:building) { create(:building, updated_at: 1.hour.ago) }

  before do
    Rails.cache.clear # Tohle zajistí, že každý test začíná s čistým štítem
  end

  describe '.call' do
    it "vrátí seznam budov přístupných pro daného uživatele" do
      result = described_class.call(user, ability)
      expect(result).to include(building)
    end

    it "použije Rails cache pro uložení výsledku" do
      # Vyčistíme cache pro jistotu
      Rails.cache.clear

      # První volání - mělo by se sáhnout do DB
      expect(Building).to receive(:accessible_by).once.and_call_original
      described_class.call(user, ability)

      # Druhé volání - mělo by to jít z Redisu, takže .accessible_by se nezavolá
      expect(Building).not_to receive(:accessible_by)
      described_class.call(user, ability)
    end

    it "změní cache klíč, když se budova zaktualizuje" do
      old_key = described_class.new(user, ability).send(:cache_key)

      # "Touch" budovy změní updated_at
      building.touch

      new_key = described_class.new(user, ability).send(:cache_key)
      expect(new_key).not_to eq(old_key)
    end
  end
end