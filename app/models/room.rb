class Room < ApplicationRecord
  belongs_to :building, touch: true
  has_many :assets, dependent: :destroy
  validates :name, :code, :building_id, :room_created_at, presence: true
end
