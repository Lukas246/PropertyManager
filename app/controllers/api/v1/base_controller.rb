module Api
  module V1 # Musí tu být V1, ne Path1
    class BaseController < ActionController::API
      before_action :authenticate_user!

      def current_user
        @current_user
      end

      def current_ability
        @current_ability ||= Ability.new(current_user)
      end

      private

      def authenticate_user!
        @current_user = User.find_by(api_key: request.headers["X-Api-Key"])
        render json: { error: "Neautorizovaný přístup" }, status: :unauthorized unless @current_user
      end
    end
  end
end
