class Asset < ApplicationRecord
  has_paper_trail
  belongs_to :room, touch: true
  has_many_attached :attachments
  validates :name, :code, :room_id, :purchase_date, :last_inspection_date, presence: true
  validates :purchase_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  def self.ransackable_attributes(auth_object = nil)
    %w[name code purchase_price purchase_date created_at room building room_id]
  end
  def self.ransackable_associations(auth_object = nil)
    %w[room building]
  end
end
