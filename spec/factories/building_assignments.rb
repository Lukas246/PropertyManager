FactoryBot.define do
  factory :building_assignment do
    association :user
    association :building
  end
end