# README



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
## Úlohy ze semestrálního projektu
1. Prezentace (ŘEŠENO)
2. UI, editace, mazání (ŘEŠENO)
3. Filtrování dat (ŘEŠENO, místnosti a majetek)
4. Vzorová data (ŘEŠENO, seed.rb, využití Faker )
5. Použití ActiveJob (ŘEŠENO, odeslání emailu s exportovanými daty, csv_export_job.rb)
6. Cachování (ŘEŠENO, využití Redis, pro budovy a místnosti)
7. Service object (ŘEŠENO, např. audit_log_service.rb pro logování změn, testy v audit_log_service_spec.rb)
8. API endpointy (řešeno, vše v controller/api/v1, testy v spec/requests)
9. Hotwire, Stimulus, Websocket (ŘEŠENO, vše v detailu budovy, lze zde přidat novou místnost přes hotwire, websocket zde umožňuje přidávat provozní poznámky a stimulus zajišťuje promazání textu zprávy po odeslání, aby odesílatel mohl psát další a nemuel starou mazat ručně ze svého textového pole)

Admin uživatel: username: admin@seznam.cz, password: password123
Správce uživatel: username: spravce.a@seznam.cz, password: password123