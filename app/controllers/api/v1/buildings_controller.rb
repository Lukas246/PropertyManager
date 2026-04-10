module Api
  module V1
    class BuildingsController < BaseController # Předpokládám BaseController pro auth
      def index
        # Recyklujeme naši ListService i s cachováním
        buildings = Buildings::ListService.call(current_user, current_ability)
        render json: buildings
      end
    end
  end
end