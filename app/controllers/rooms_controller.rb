class RoomsController < ApplicationController
  load_and_authorize_resource
  before_action :set_room, only: %i[ show edit update destroy ]

  # GET /rooms or /rooms.json
  def index
    # Klíč obsahuje entitu, roli a čas poslední změny jakékoli místnosti
    cache_key = [
      "rooms",
      "role-#{current_user.role}",
      Room.maximum(:updated_at).to_i
    ]

    @rooms = Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      # Respektujeme autorizaci přes CanCanCan/Pundit
      Room.accessible_by(current_ability).to_a
    end
  end

  # GET /rooms/1 or /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.turbo_stream
        format.html { redirect_to @room, notice: "Room was successfully created." }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: "Room was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy!

    respond_to do |format|
      format.html { redirect_to rooms_path, notice: "Room was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.expect(room: [ :name, :code, :building_id, :room_created_at ])
    end
end
