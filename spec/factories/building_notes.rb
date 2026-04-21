FactoryBot.define do
  factory :building_note do
    building { nil }
    user { nil }
    body { "MyText" }
  end
end
