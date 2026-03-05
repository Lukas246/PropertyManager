class User < ApplicationRecord
  before_create :generate_api_key
  enum :role, { admin: "admin", spravce: "správce", ctenar: "čtenář" }

  validates :full_name, :role, :email, :member_code, presence: true
  validates :email, :member_code, uniqueness: true

  private
  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
