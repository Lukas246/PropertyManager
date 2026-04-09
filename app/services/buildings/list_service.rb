module Buildings
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
        # Výkonný kód, který se spustí jen při Cache Miss
        Building.accessible_by(ability).to_a
      end
    end

    private

    def cache_key
      [
        "buildings",
        "role-#{user.role}",
        "v1",
        Building.maximum(:updated_at).to_i
      ]
    end
  end
end