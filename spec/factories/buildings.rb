FactoryBot.define do
  factory :building do
    name { "Budova A" }
    contact_person_email { "test@budova.cz" }
    contact_person_phone { "123456789" }
    building_created_at { Time.current }
    sequence(:code) { |n| "BLD-#{n}" }
  end
end
