module Assets
  class AuditLogService
    def self.call(asset)
      # Cachujeme celý výsledek transformace.
      # Klíč se změní, jakmile přibude nová verze (změna majetku).
      cache_key = "asset/#{asset.id}/audit_log/v1-#{asset.versions.maximum(:created_at).to_i}"

      Rails.cache.fetch(cache_key, expires_in: 12.hours) do
        asset.versions.map do |version|
          {
            id: version.id,
            event: version.event, # create, update, destroy
            whodunnit: find_user_name(version.whodunnit),
            changes: version.changeset, # Vyžaduje zapnuté object_changes v PaperTrail
            created_at: version.created_at
          }
        end
      end
    end

    private

    def self.find_user_name(whodunnit)
      return "Systém" if whodunnit.blank?

      # Tady je dobré použít malou cache na jména uživatelů,
      # aby se neprováděl DB dotaz na Usera u každého řádku logu
      Rails.cache.fetch("user_name/#{whodunnit}", expires_in: 1.hour) do
        User.find_by(id: whodunnit)&.email || "Neznámý uživatel (#{whodunnit})"
      end
    end
  end
end