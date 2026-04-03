FactoryBot.define do
  factory :user do
    full_name { "Testovací Uživatel" }
    sequence(:email) { |n| "user#{n}@test.cz" }
    password { "password123" }
    role { :spravce }
    member_code { "M#{rand(1000..9999)}" }

    trait :admin do
      role { :admin }
    end
  end
end
