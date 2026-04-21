# Dockerfile
ARG RUBY_VERSION=3.4.7
FROM ruby:$RUBY_VERSION-slim

# Instalace závislostí pro vývoj (včetně sqlite, vips a build tools)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips \
    curl \
    sqlite3 \
    libyaml-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

WORKDIR /rails

# Nastavení vývojového prostředí
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Instalace gemů
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Kopírování zbytku aplikace
COPY . .

# Entrypoint vyřeší mazání server.pid a databázi
COPY bin/docker-entrypoint /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]