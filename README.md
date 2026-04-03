# README

Projekt je rozpracovaný a obsahuje i provizorní views. 

## Požadavky
- Ruby 3.x
- Rails 7.x
- SQLite3
- ImageMagick nebo vips (pro náhledy příloh)



- spustit `bundle install`
- vytvořit databázi `rails db:create`
- vytvořit tabulky `rails db:migrate`
- vytvořit data `rails db:seed`
- spustit `rails server`

## Úlohy z přůběžného úkolu

1. Projekt bude obsahovat tabulky pro jednotlivé entity, bude mít definované relace
   mezi nimi a validace (ŘEŠENO)
2. V aplikaci budou dostupné API endpointy, přístupné přes Api-Klíč 
   a. endpoint pro výpis majetku - ŘEŠENO (controllers/api/v1/assets_controller.rb)
   b. endpoint pro vytvoření/úpravu/smazání majetku - ŘEŠENO (controllers/api/v1/assets_controller.rb)
3. Jednotlivé entity budou mít napsané testy
   a. validace, asociace ŘEŠENO (spec/models)
   b. API endpointy ŘEŠENO (spec/requests)

Admin uživatel: username: admin@seznam.cz, password: password123
Správce uživatel: username: spravce.a@seznam.cz, password: password123