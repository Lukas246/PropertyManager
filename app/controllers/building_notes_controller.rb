class BuildingNotesController < ApplicationController
  def create
    @building = Building.find(params[:building_id])
    @note = @building.building_notes.build(note_params)
    @note.user = current_user

    @note.save

  end

  private

  def note_params
    params.require(:building_note).permit(:body)
  end
end