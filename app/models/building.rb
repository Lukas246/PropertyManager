class Building < ApplicationRecord
  after_destroy :touch_all_buildings
  has_many :building_assignments, dependent: :destroy
  has_many :managers, through: :building_assignments, source: :user
  has_many :rooms, dependent: :destroy
  validates :name, :code, :contact_person_email, :contact_person_phone, :building_created_at, presence: true
  validates :code, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "code"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["rooms"]
  end

  private
  def touch_all_buildings
    Rails.cache.delete_matched("buildings/role-*")
  end
end
