require 'rails_helper'

RSpec.describe Room, type: :model do
  # Test asociací
  it "patří do budovy" do
    association = described_class.reflect_on_association(:building)
    expect(association.macro).to eq :belongs_to
  end

  # Test validací
  it "vyžaduje název, kód a datum vytvoření" do
    room = Room.new(name: nil, code: nil)
    expect(room).not_to be_valid
  end
end
