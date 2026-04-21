class BuildingNote < ApplicationRecord
  belongs_to :building
  belongs_to :user

  validates :body, presence: true

  after_create_commit -> { broadcast_append_to building, target: "notes_list" }
end
