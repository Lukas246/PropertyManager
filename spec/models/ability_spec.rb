require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  context "když je uživatel správce" do
    let(:user) { create(:user, role: :spravce) }
    let(:moje_budova) { create(:building) }
    let(:cizi_budova) { create(:building, name: "Cizí") }

    before do
      create(:building_assignment, user: user, building: moje_budova)
    end

    it { is_expected.to be_able_to(:manage, moje_budova) }
    it { is_expected.not_to be_able_to(:manage, cizi_budova) }
  end

  context "když je uživatel admin" do
    let(:user) { create(:user, :admin) }

    it { is_expected.to be_able_to(:manage, :all) }
  end
end