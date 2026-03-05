class Asset < ApplicationRecord
  belongs_to :room
  validates :name, :code, :room_id, :purchase_date, :last_inspection_date, presence: true
end
