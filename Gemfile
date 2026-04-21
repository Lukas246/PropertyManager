source "https://rubygems.org"

ruby "3.4.7" # Doporučeno specifikovat verzi podle Dockeru

gem "rails", "~> 8.1.1"

# --- CORE & DATABASE ---
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "propshaft"            # Moderní asset pipeline
gem "bootsnap", require: false
gem "image_processing", "~> 1.2"
gem "psych", "~> 5.2"

# --- FRONTEND & API ---
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# --- AUTH & PERMISSIONS ---
gem "devise"
gem "cancancan"

# --- AUDIT & UTILITIES ---
gem "paper_trail"
gem "csv"
gem "kaminari", "~> 1.2"   # Stránkování
gem "ransack", "~> 4.4"    # Vyhledávání
gem "rqrcode", "~> 3.2"    # QR kódy

# --- BACKGROUND JOBS & CACHING (Redis + Sidekiq) ---
gem "redis"
gem "sidekiq"

# --- SOLID STACK (Rails 8 default) ---
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# --- DEPLOYMENT & PRODUCTION TOOLS ---
gem "kamal", require: false
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

# --- DEVELOPMENT & TEST ---
group :development, :test do
  gem "rspec-rails"        # Přesunuto sem, kde to má smysl
  gem "factory_bot_rails"
  gem "faker"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Statická analýza a bezpečnost
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

# --- DEVELOPMENT ONLY ---
group :development do
  gem "bullet"             # Bullet stačí mít v developmentu
end

# --- TEST ONLY ---
group :test do
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
  gem "capybara"
  gem "selenium-webdriver"
end