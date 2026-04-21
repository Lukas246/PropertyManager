FactoryBot.define do
    factory :user do
      full_name { Faker::Name.name }
      sequence(:email) { |n| "user#{n}@test.cz" } # Zaručí unikátní email
      password { 'password123' }
      role { 'ctenar' }
      member_code { SecureRandom.hex(4).upcase } # Vygeneruje náhodný kód

    trait :admin do
      role { 'admin' }
    end
  end
end
