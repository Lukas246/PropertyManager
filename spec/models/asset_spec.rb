require 'rails_helper'

RSpec.describe Asset, type: :model do
  it "není validní bez názvu" do
    asset = Asset.new(name: nil)
    expect(asset).not_to be_valid
  end

  it "patří do místnosti" do
    association = described_class.reflect_on_association(:room)
    expect(association.macro).to eq :belongs_to
  end

  it "vyžaduje datum nákupu a poslední kontroly" do
    asset = Asset.new(purchase_date: nil, last_inspection_date: nil)
    expect(asset).not_to be_valid
  end
end
