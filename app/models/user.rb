class User < ApplicationRecord
  has_many :building_assignments, dependent: :destroy
  has_many :managed_buildings, through: :building_assignments, source: :building

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :generate_api_key
  enum :role, { admin: "admin", spravce: "správce", ctenar: "čtenář" }

  validates :full_name, :role, :email, :member_code, presence: true
  validates :email, :member_code, uniqueness: true

  private
  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
