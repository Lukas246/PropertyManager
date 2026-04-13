class User < ApplicationRecord
  has_many :building_assignments, dependent: :destroy
  has_many :managed_buildings, through: :building_assignments, source: :building
  has_many :building_notes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  before_create :generate_api_key
  enum :role, { admin: "admin", spravce: "správce", ctenar: "čtenář" }

  validates :full_name, :role, :email, :member_code, presence: true
  validates :email, :member_code, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "email",
      "full_name",         # Pokud máš jméno v jednom sloupci
      "role",
      "member_code",
      "api_key",
      "current_sign_in_at",
      "created_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[building_assignments managed_buildings]
  end

  private
  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
