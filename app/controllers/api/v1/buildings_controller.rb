module Api
  module V1
    class BuildingsController < BaseController
      def index
        # Recyklujeme ListService i s cachováním
        buildings = Buildings::ListService.call(current_user, current_ability)
        render json: buildings
      end
    end
  end
end
