require 'rails_helper'

RSpec.describe Building, type: :model do
  # Test asociací - Budova má mnoho místností
  it "má mnoho místností" do
    association = described_class.reflect_on_association(:rooms)
    expect(association.macro).to eq :has_many
  end

  # Test validací
  it "není validní bez povinných polí" do
    building = Building.new(name: nil, code: nil, contact_person_email: nil)
    expect(building).not_to be_valid
  end

  it "vyžaduje unikátní kód budovy" do
    Building.create!(name: "A", code: "B01", contact_person_email: "a@b.cz", contact_person_phone: "1", building_created_at: Date.today)
    duplicate = Building.new(code: "B01")
    expect(duplicate).not_to be_valid
  end
end