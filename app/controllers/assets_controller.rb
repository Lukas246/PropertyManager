class AssetsController < ApplicationController
  load_and_authorize_resource
  before_action :set_asset, only: %i[ show edit update destroy ]

  # GET /assets or /assets.json
  def index
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

    # Podpora pro CSV export (jak jsme psali minule), aby exportoval i vyfiltrovaná data
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@assets), filename: "export-majetku-#{Date.today}.csv" }
    end
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
