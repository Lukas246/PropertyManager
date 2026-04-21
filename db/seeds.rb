# db/seeds.rb

require 'faker'

# Nastavíme Faker na češtinu, ať máme reálná česká jména a adresy
Faker::Config.locale = 'cs'

puts "🧹 --- Čistím databázi ---"
# Mažeme v opačném pořadí závislostí
BuildingAssignment.destroy_all
Asset.destroy_all
Room.destroy_all
Building.destroy_all
User.destroy_all

puts "👤 --- Vytvářím uživatele ---"
# 1. Pevně daný Admin (přesně jak jste chtěl)
admin = User.create!(
  full_name: "Hlavní Administrátor",
  email: "admin@seznam.cz",
  password: "password123",
  password_confirmation: "password123",
  role: :admin,
  member_code: "ADM-001"
)
puts "  ✅ Hlavní admin vytvořen."

# 2. Vytvoříme 3 Správce pomocí Fakera
managers = []
3.times do |i|
  managers << User.create!(
    full_name: Faker::Name.name,
    email: "spravce#{i + 1}@seznam.cz", # Můžete se přihlásit jako spravce1@seznam.cz atd.
    password: "password123",
    password_confirmation: "password123",
    role: :spravce,
    member_code: "SPR-#{Faker::Alphanumeric.alphanumeric(number: 5).upcase}"
  )
end
puts "  ✅ #{managers.count} správců vytvořeno."

# 3. Vytvoříme 10 běžných uživatelů
users = []
10.times do
  users << User.create!(
    full_name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password123",
    password_confirmation: "password123",
    role: :ctenar,
    member_code: "USR-#{Faker::Alphanumeric.alphanumeric(number: 5).upcase}"
  )
end
puts "  ✅ #{users.count} běžných uživatelů vytvořeno."


puts "🏢 --- Vytvářím budovy ---"
buildings = []
8.times do |i|
  buildings << Building.create!(
    name: "#{Faker::Company.name} - #{Faker::Address.city}",
    code: "BLD-#{100 + i}",
    address: Faker::Address.full_address,
    contact_person_email: Faker::Internet.email,
    contact_person_phone: Faker::PhoneNumber.phone_number,
    building_created_at: Faker::Time.backward(days: 1000)
  )
end
puts "  ✅ #{buildings.count} budov vytvořeno."


puts "🔑 --- Přiřazuji správce k budovám ---"
# Každá budova dostane náhodně jednoho z našich 3 správců
buildings.each do |building|
  BuildingAssignment.create!(
    user: managers.sample,
    building: building
  )
end
puts "  ✅ Správci byli přiřazeni k budovám."


puts "🚪 --- Vytvářím místnosti ---"
room_types = [ "Kancelář", "Zasedačka", "Sklad", "Kuchyňka", "IT oddělení", "Serverovna", "Recepce" ]
rooms = []

buildings.each do |building|
  # Každá budova bude mít 3 až 8 místností
  rand(3..8).times do |i|
    rooms << Room.create!(
      name: "#{room_types.sample} #{i + 1}",
      code: "#{building.code.split('-').last}-#{100 + i}",
      building: building,
      room_created_at: Faker::Time.backward(days: 500)
    )
  end
end
puts "  ✅ #{rooms.count} místností rozděleno do budov."


puts "📦 --- Vytvářím ukázkový majetek ---"
asset_names = [
  "MacBook Pro 14", "Dell XPS 15", "Monitor Dell 27", "Monitor HP 24",
  "Kancelářská židle Herman Miller", "Kancelářská židle Ikea Markus",
  "Stůl polohovací", "Tiskárna HP LaserJet", "Projektor Epson",
  "Skartovačka Fellowes", "Kávovar DeLonghi", "Klimatizace mobilní"
]

assets_created = 0

rooms.each do |room|
  # Každá místnost dostane náhodně 2 až 12 kusů majetku
  rand(2..12).times do
    Asset.create!(
      name: asset_names.sample,
      code: "INV-#{Time.now.year}-#{Faker::Alphanumeric.alphanumeric(number: 6).upcase}",
      room: room,
      purchase_date: Faker::Date.backward(days: 1500),
      # Někdy majetek má revizi, někdy je nil (pro otestování warningů ve view)
      last_inspection_date: [ Faker::Date.backward(days: 400) ].sample,
      purchase_price: Faker::Commerce.price(range: 1500..65000),
      # Poznámku přidáme jen u zhruba 30 % majetku
      note: [ Faker::Lorem.sentence, "", "" ].sample
    )
    assets_created += 1
  end
end
puts "  ✅ #{assets_created} kusů majetku rozmístěno do místností."

puts "🎉 --- Hotovo! Seeds byly úspěšně nahrány. --- 🎉"
