class Asset < ApplicationRecord
  has_paper_trail
  belongs_to :room
  has_many_attached :attachments
  validates :name, :code, :room_id, :purchase_date, :last_inspection_date, presence: true
end
