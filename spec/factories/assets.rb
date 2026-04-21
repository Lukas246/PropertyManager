FactoryBot.define do
  factory :asset do
    name { "Kancelářská židle" }
    code { "ZID-#{rand(1000..9999)}" }
    purchase_price { 4500.0 }
    purchase_date { Date.today - 1.year }
    last_inspection_date { Date.today - 6.months }
    room # Automaticky vytvoří asociovanou místnost (a ta budovu)
  end
end
