# config/initializers/paper_trail.rb

# Použijeme to_prepare, aby se kód spustil až po načtení gemů
Rails.application.config.to_prepare do
  # 1. Nastavení serializeru (musí být uvnitř bloku)
  PaperTrail.config.serializer = PaperTrail::Serializers::JSON

  # 2. Definice vazby na uživatele
  # Použijeme ActiveSupport.on_load, což je nejstabilnější cesta v Rails
  ActiveSupport.on_load(:active_record) do
    if defined?(PaperTrail::Version)
      PaperTrail::Version.class_eval do
        belongs_to :user, class_name: "User", foreign_key: :whodunnit, optional: true
      end
    end
  end
end
