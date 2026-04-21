module Rooms
  class ListService
    attr_reader :user, :ability

    def self.call(user, ability)
      new(user, ability).call
    end

    def initialize(user, ability)
      @user = user
      @ability = ability
    end

    def call
      Rails.cache.fetch(cache_key, expires_in: 24.hours) do
        # Do cache se uloží jen ty místnosti, na které má uživatel právo
        Room.accessible_by(ability).to_a
      end
    end

    private

    def cache_key
      [
        "rooms",
        "role-#{user.role}",
        "v1",
        # Rychlý SQL dotaz na zjištění, jestli se jakákoliv místnost změnila
        Room.maximum(:updated_at).to_i
      ]
    end
  end
end
