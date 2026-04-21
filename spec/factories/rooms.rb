FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "Místnost #{n}" }
    code { "R-#{rand(1000..9999)}" }
    building # Automaticky vytvoří asociovanou budovu
    room_created_at { Date.today - 1.year }
  end
end
