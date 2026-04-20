class Room < ApplicationRecord
  belongs_to :building, touch: true
  has_many :assets, dependent: :destroy
  validates :name, :code, :building_id, :room_created_at, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name code building_id room_created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[building assets]
  end
end
