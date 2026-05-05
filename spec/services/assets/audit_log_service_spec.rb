require 'rails_helper'

RSpec.describe Assets::AuditLogService, type: :service do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:asset) { create(:asset) }

  # Simulace verzí (PaperTrail style)
  let(:version_1) do
    instance_double(
      'PaperTrail::Version',
      id: 101,
      event: 'create',
      whodunnit: nil,
      changeset: { 'name' => [nil, 'První majetek'] },
      created_at: 2.hours.ago
    )
  end

  let(:version_2) do
    instance_double(
      'PaperTrail::Version',
      id: 102,
      event: 'update',
      whodunnit: user.id.to_s,
      changeset: { 'value' => [100, 200] },
      created_at: 1.hour.ago
    )
  end

  before do
    # Vyčistíme cache před každým testem
    Rails.cache.clear

    # Nastavíme mocky pro vazby assetu
    allow(asset).to receive(:id).and_return(55)
    allow(asset).to receive(:versions).and_return([version_1, version_2])
    # Simulace pro výpočet cache_key
    allow(asset.versions).to receive(:maximum).with(:created_at).and_return(version_2.created_at)
  end

  describe '.call' do
    it 'vrátí správně zformátované pole auditních záznamů' do
      result = described_class.call(asset)

      expect(result.size).to eq(2)
      expect(result.first[:event]).to eq('create')
      expect(result.first[:whodunnit]).to eq('Systém')

      expect(result.last[:event]).to eq('update')
      expect(result.last[:whodunnit]).to eq('test@example.com')
      expect(result.last[:changes]).to eq({ 'value' => [100, 200] })
    end

    it 'používá cache pro výsledek transformace' do
      # 1. volání: Přistoupí se k verzím pro klíč i pro data (map)
      described_class.call(asset)

      # 2. volání:
      # Metoda .maximum se zavolá VŽDY (kvůli výpočtu cache_key).
      # Ale .map (nebo iterace přes kolekci) by se už zavolat NEMĚLA.

      # Resetujeme trackování volání po prvním průchodu
      expect(asset.versions).to receive(:maximum).once # Pro klíč
      expect(asset.versions).not_to receive(:map)     # Pro data (půjde z cache)

      described_class.call(asset)
    end

    it 'vygeneruje unikátní cache_key podle ID a času poslední verze' do
      timestamp = version_2.created_at.to_i
      expected_key = "asset/55/audit_log/v1-#{timestamp}"

      # Použijeme .at_least(:once), protože fetch se volá i pro uživatele uvnitř
      expect(Rails.cache).to receive(:fetch).with(expected_key, hash_including(expires_in: 12.hours)).and_call_original

      # Povolíme ostatní volání cache (pro uživatele), aby test neselhal
      allow(Rails.cache).to receive(:fetch).with(kind_of(String), hash_including(expires_in: 1.hour)).and_call_original

      described_class.call(asset)
    end
  end

  describe '.find_user_name (private)' do
    it 'vrátí "Systém" pokud je whodunnit prázdné' do
      # Volání privátní metody přes send pro účely testu
      expect(described_class.send(:find_user_name, nil)).to eq('Systém')
    end

    it 'vrátí email uživatele, pokud existuje' do
      expect(described_class.send(:find_user_name, user.id)).to eq('test@example.com')
    end

    it 'vrátí informaci o neznámém uživateli, pokud ID neexistuje' do
      expect(described_class.send(:find_user_name, 999)).to eq('Neznámý uživatel (999)')
    end
  end
end
