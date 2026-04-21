require "csv"

class CsvExportJob < ApplicationJob
  queue_as :default

  def perform(user_id, filters)
    user = User.find(user_id)

    # 1. Zrekonstruujeme dotaz podle filtrů (stejně jako v controlleru)
    assets = Asset.all

    # Ošetření toho, co má daný uživatel vidět (podle CanCanCan / Role)
    if user.role == "spravce"
      assets = assets.joins(room: { building: :building_assignments })
                     .where(building_assignments: { user_id: user.id })
    end

    # Aplikace samotných filtrů
    assets = assets.where("name LIKE ? OR code LIKE ?", "%#{filters['query']}%", "%#{filters['query']}%") if filters["query"].present?
    assets = assets.where(room_id: filters["room_id"]) if filters["room_id"].present?
    assets = assets.where("purchase_price >= ?", filters["price_from"]) if filters["price_from"].present?
    assets = assets.where("purchase_price <= ?", filters["price_to"]) if filters["price_to"].present?
    assets = assets.where("purchase_date >= ?", filters["purchase_date_from"]) if filters["purchase_date_from"].present?
    assets = assets.where("purchase_date <= ?", filters["purchase_date_to"]) if filters["purchase_date_to"].present?

    # 2. Vygenerujeme CSV
    csv_string = generate_csv(assets)

    puts "------- START CSV -------"
    puts csv_string
    puts "------- KONEC CSV -------"

    # 3. Odešleme e-mail
    ExportMailer.send_csv(user, csv_string).deliver_now
  end

  private
  def generate_csv(assets)
    CSV.generate(col_sep: ";", encoding: "UTF-8") do |csv|
      csv << [ "\xEF\xBB\xBFID", "Název", "Kód", "Budova", "Místnost", "Cena", "Datum nákupu" ]
      assets.each do |asset|
        csv << [
          asset.id,
          asset.name,
          asset.code,
          asset.room.building.name,
          asset.room.name,
          asset.purchase_price,
          asset.purchase_date
        ]
      end
    end
  end
end
