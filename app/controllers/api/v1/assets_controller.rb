module Api
  module V1
    class AssetsController < BaseController
      before_action :set_asset, only: [:update, :destroy]

      # a. Endpoint pro výpis majetku (GET /api/v1/inventura)
      def index
        @assets = Asset.all
        render json: @assets
      end

      # b. Endpoint pro vytvoření (POST /api/v1/inventura)
      def create
        @asset = Asset.new(asset_params)
        if @asset.save
          render json: @asset, status: :created
        else
          render json: { errors: @asset.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # b. Endpoint pro úpravu (PATCH/PUT /api/v1/inventura/:id)
      def update
        if @asset.update(asset_params)
          render json: @asset
        else
          render json: { errors: @asset.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # b. Endpoint pro smazání (DELETE /api/v1/inventura/:id)
      def destroy
        @asset.destroy
        head :no_content
      end

      private

      def set_asset
        @asset = Asset.find(params[:id])
      end

      def asset_params
        params.require(:asset).permit(:name, :code, :room_id, :purchase_date, :last_inspection_date, :note, :purchase_price)
      end
    end
  end
end