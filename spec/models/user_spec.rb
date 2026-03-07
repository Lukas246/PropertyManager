require 'rails_helper'

RSpec.describe User, type: :model do
  it "vyžaduje roli a kód člena" do
    user = User.new(role: nil, member_code: nil)
    expect(user).not_to be_valid
  end

  it "vyžaduje unikátní e-mail" do
    User.create!(full_name: "Jan", email: "jan@test.cz", role: "admin", member_code: "1")
    duplicate = User.new(email: "jan@test.cz")
    expect(duplicate).not_to be_valid
  end
end