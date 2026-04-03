# db/seeds.rb

puts "--- Čistím databázi ---"
# Mažeme v opačném pořadí závislostí
BuildingAssignment.destroy_all
Asset.destroy_all
Room.destroy_all
Building.destroy_all
User.destroy_all

puts "--- Vytvářím uživatele ---"
admin = User.create!(
  full_name: "Hlavní Administrátor",
  email: "admin@seznam.cz",
  password: "password123",
  password_confirmation: "password123",
  role: :admin,
  member_code: "ADM001"
)

spravce_a = User.create!(
  full_name: "Jan Správce (Budova A)",
  email: "spravce.a@seznam.cz",
  password: "password123",
  password_confirmation: "password123",
  role: :spravce,
  member_code: "SPR001"
)

puts "--- Vytvářím budovy ---"
# Tady jsem přidal pole, která tvoje validace vyžadovala
b_praha = Building.create!(
  name: "Centrála Praha",
  code: "PRG-01",
  address: "Václavské nám. 1",
  contact_person_email: "praha@firma.cz",      # DOPLNĚNO
  contact_person_phone: "+420 111 222 333",    # DOPLNĚNO
  building_created_at: Time.current             # DOPLNĚNO
)

b_brno = Building.create!(
  name: "Pobočka Brno",
  code: "BRN-02",
  address: "Svobody 10",
  contact_person_email: "brno@firma.cz",       # DOPLNĚNO
  contact_person_phone: "+420 444 555 666",    # DOPLNĚNO
  building_created_at: Time.current             # DOPLNĚNO
)

puts "--- Vytvářím místnosti ---"
r1 = Room.create!(name: "IT Oddělení", code: "101", building: b_praha, room_created_at: 1.year.ago)
r2 = Room.create!(name: "Zasedačka", code: "202", building: b_praha, room_created_at: 2.years.ago)
r3 = Room.create!(name: "Sklad Brno", code: "S01", building: b_brno, room_created_at: 1.year.ago)

puts "--- Přiřazuji správce k budově ---"
BuildingAssignment.create!(user: spravce_a, building: b_praha)

puts "--- Vytvářím ukázkový majetek ---"
Asset.create!(
  name: "MacBook Pro 14",
  code: "INV-2026-001",
  room: r1,
  purchase_date: 1.year.ago,
  last_inspection_date: 1.month.ago,
  purchase_price: 55000,
  note: "Hlavní pracovní stroj"
)

Asset.create!(
  name: "Kancelářská židle Herman Miller",
  code: "INV-2026-002",
  room: r2,
  purchase_date: 2.years.ago,
  last_inspection_date: 6.months.ago,
  purchase_price: 35000
)

puts "--- Hotovo! Seeds byly úspěšně nahrány. ---"