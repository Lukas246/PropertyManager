class BuildingAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :building

  validates :user_id, uniqueness: { scope: :building_id, message: "tento správce již k budově patří" }
end
