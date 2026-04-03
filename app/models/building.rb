class Building < ApplicationRecord
  has_many :building_assignments, dependent: :destroy
  has_many :managers, through: :building_assignments, source: :user
  has_many :rooms, dependent: :destroy
  validates :name, :code, :contact_person_email, :contact_person_phone, :building_created_at, presence: true
  validates :code, uniqueness: true
end
