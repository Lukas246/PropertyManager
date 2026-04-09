module Api
  class RoomsController < BaseController
    def index
      @rooms = Rooms::ListService.call(current_user, current_ability)
      render json: @rooms
    end
  end
end