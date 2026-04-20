class AssetsController < ApplicationController
  load_and_authorize_resource
  before_action :set_asset, only: %i[ show edit update destroy ]

  # GET /assets or /assets.json
  def index
    @q = Asset.accessible_by(current_ability).includes(room: :building).ransack(params[:q])

    if current_user.role == "admin"
      @assets = Asset.all
    elsif current_user.role == "spravce"
      @assets = Asset.joins(room: { building: :building_assignments })
                     .where(building_assignments: { user_id: current_user.id })
    else
      @assets = Asset.none # Nebo jen read-only pokud chceš
    end

    # 1. Fulltextové vyhledávání (Název, Kód, Poznámka)
    if params[:query].present?
      q = "%#{params[:query]}%"
      @assets = @assets.where("name LIKE ? OR code LIKE ? OR note LIKE ?", q, q, q)
    end

    # 2. Rozsahový filtr pro Datum nákupu (od - do)
    if params[:purchase_date_from].present?
      @assets = @assets.where("purchase_date >= ?", params[:purchase_date_from])
    end
    if params[:purchase_date_to].present?
      @assets = @assets.where("purchase_date <= ?", params[:purchase_date_to])
    end

    # 3. Rozsahový filtr pro Cenu (od - do)
    if params[:price_from].present?
      @assets = @assets.where("purchase_price >= ?", params[:price_from])
    end
    if params[:price_to].present?
      @assets = @assets.where("purchase_price <= ?", params[:price_to])
    end

    # 4. Filtr podle místnosti (pokud už tam byl)
    if params[:room_id].present?
      @assets = @assets.where(room_id: params[:room_id])
    end

    # Podpora pro CSV export
    respond_to do |format|
      format.html
      format.csv do
        # 1. Zabalíme filtry do čistého hashe (ActiveJob nemá rád složité ActionController parametry)
        safe_filters = {
          "query" => params[:query],
          "room_id" => params[:room_id],
          "price_from" => params[:price_from],
          "price_to" => params[:price_to],
          "purchase_date_from" => params[:purchase_date_from],
          "purchase_date_to" => params[:purchase_date_to]
        }

        # 2. Odošleme úlohu na pozadí (perform_later zajistí, že se to nespustí v hlavním vlákně)
        CsvExportJob.perform_later(current_user.id, safe_filters)

        # 3. Přesměrujeme zpět s upozorněním
        redirect_to assets_path(request.query_parameters.except(:format)), notice: "Export se zpracovává na pozadí. Jakmile bude hotový, pošleme vám ho na e-mail."
      end
    end
    @assets = @q.result(distinct: true).page(params[:page]).per(15)
    @available_rooms = Room.accessible_by(current_ability).order(:name)
  end

  # GET /assets/1 or /assets/1.json
  def show
  end

  # GET /assets/new
  def new
    @asset = Asset.new
  end

  # GET /assets/1/edit
  def edit
  end

  # POST /assets or /assets.json
  def create
    @asset = Asset.new(asset_params)

    respond_to do |format|
      if @asset.save
        format.html { redirect_to @asset, notice: "Asset was successfully created." }
        format.json { render :show, status: :created, location: @asset }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assets/1 or /assets/1.json
  def update
    # 1. Vytáhneme nové přílohy z parametrů dříve, než proběhne update,
    # aby je Rails automaticky nepřepsaly.
    new_attachments = params[:asset].delete(:attachments)

    respond_to do |format|
      # 2. Provedeme update ostatních polí (název, cena, atd.)
      if @asset.update(asset_params)

        # 3. Pokud uživatel vybral nové soubory, ručně je připojíme k těm starým
        @asset.attachments.attach(new_attachments) if new_attachments.present?

        format.html { redirect_to @asset, notice: "Majetek byl úspěšně upraven.", status: :see_other }
        format.json { render :show, status: :ok, location: @asset }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1 or /assets/1.json
  def destroy
    @asset.destroy!

    respond_to do |format|
      format.html { redirect_to assets_path, notice: "Asset was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
      format.csv { send_data generate_csv(@assets), filename: "export-majetku-#{Date.today}.csv" }
    end
  end

  def purge_attachment
    @asset = Asset.find(params[:id])
    attachment = @asset.attachments.find(params[:attachment_id])
    attachment.purge # Toto fyzicky smaže soubor i vazbu

    redirect_back fallback_location: edit_asset_path(@asset), notice: "Příloha byla smazána."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = Asset.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def asset_params
      params.expect(asset: [ :name, :code, :room_id, :purchase_date, :last_inspection_date, :note, :purchase_price, attachments: [] ])
    end

  def generate_csv(assets)
    CSV.generate(col_sep: ";", encoding: "UTF-8") do |csv|
      # Hlavička
      csv << ["ID", "Název", "Kód", "Budova", "Místnost", "Cena", "Datum nákupu"]

      # Data
      assets.each do |asset|
        csv << [
          asset.id,
          asset.name,
          asset.code,
          asset.room.building.name,
          asset.room.name,
          asset.purchase_price,
          asset.purchase_date
        ]
      end
    end
  end
end
