# config/initializers/paper_trail.rb

# Nastavíme JSON jako serializátor (v Rails 7 je to nejstabilnější cesta)
PaperTrail.config.serializer = PaperTrail::Serializers::JSON

# Zapne sledování asociací (pokud budeš chtít sledovat i změny v místnostech u majetku)
