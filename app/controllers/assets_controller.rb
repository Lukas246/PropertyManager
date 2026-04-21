class AssetsController < ApplicationController
  load_and_authorize_resource
  before_action :set_asset, only: %i[ show edit update destroy ]

  # GET /assets or /assets.json
  def index
    @assets = if current_user.role == "admin"
                Asset.all
    elsif current_user.role == "spravce"
                Asset.joins(room: { building: :building_assignments })
                     .where(building_assignments: { user_id: current_user.id })
    else
                Asset.none
    end
    @assets = @assets.includes(room: :building)

    # 2. MANUÁLNÍ FILTRY
    if params[:query].present?
      q_param = "%#{params[:query]}%"
      @assets = @assets.where("assets.name LIKE ? OR assets.code LIKE ? OR assets.note LIKE ?", q_param, q_param, q_param)
    end

    if params[:purchase_date_from].present?
      @assets = @assets.where("purchase_date >= ?", params[:purchase_date_from])
    end
    if params[:purchase_date_to].present?
      @assets = @assets.where("purchase_date <= ?", params[:purchase_date_to])
    end

    if params[:price_from].present?
      @assets = @assets.where("purchase_price >= ?", params[:price_from])
    end
    if params[:price_to].present?
      @assets = @assets.where("purchase_price <= ?", params[:price_to])
    end

    if params[:room_id].present?
      @assets = @assets.where(room_id: params[:room_id])
    end

    # RANSACK
    @q = @assets.ransack(params[:q])
    @assets = @q.result(distinct: true).page(params[:page]).per(15)

    # RESPONSE A EXPORTY
    respond_to do |format|
      format.html
      format.csv do
        safe_filters = {
          "query" => params[:query], "room_id" => params[:room_id],
          "price_from" => params[:price_from], "price_to" => params[:price_to],
          "purchase_date_from" => params[:purchase_date_from], "purchase_date_to" => params[:purchase_date_to]
        }
        CsvExportJob.perform_later(current_user.id, safe_filters)
        redirect_to assets_path(request.query_parameters.except(:format)), notice: "Export se zpracovává na pozadí."
      end
    end

    @available_rooms = Room.accessible_by(current_ability).order(:name)
  end

  def show
  end

  def new
    @asset = Asset.new
  end

  def edit
  end

  def create
    @asset = Asset.new(asset_params)
    if @asset.save
      redirect_to @asset, notice: "Majetek byl úspěšně vytvořen."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    new_attachments = params[:asset].delete(:attachments)
    if @asset.update(asset_params)
      @asset.attachments.attach(new_attachments) if new_attachments.present?
      redirect_to @asset, notice: "Majetek byl úspěšně upraven.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @asset.destroy!
    redirect_to assets_path, notice: "Majetek byl smazán.", status: :see_other
  end

  def purge_attachment
    attachment = @asset.attachments.find(params[:attachment_id])
    attachment.purge
    redirect_back fallback_location: edit_asset_path(@asset), notice: "Příloha byla smazána."
  end

  private

  def set_asset
    # Základní find pro všechny akce
    base_query = Asset.find(params[:id])

    @asset = case action_name
    when "show"
               # Pro show chceme VŠECHNO (kvůli historii a detailům)
               Asset.includes({ room: :building }, { versions: [ :item, :user ] }, :attachments_attachments).find(params[:id])
    when "edit"
               # Pro edit nám stačí jen majetek a jeho obrázky (pokud je ve formuláři ukazuješ)
               Asset.includes(:attachments_attachments).find(params[:id])
    else
               # Pro update, destroy atd. stačí čistý základ
               base_query
    end
  end

  def asset_params
    params.require(:asset).permit(:name, :code, :room_id, :purchase_date, :last_inspection_date, :note, :purchase_price, attachments: [])
  end
end
