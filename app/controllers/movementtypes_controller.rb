class MovementtypesController < ApplicationController
  before_action :set_movementtype, only: [:show, :edit, :update, :destroy]

  # GET /movementtypes
  # GET /movementtypes.json
  def index
    @movementtypes = current_user.movementtypes.all
  end

  # GET /movementtypes/1
  # GET /movementtypes/1.json
  def show
  end

  # GET /movementtypes/new
  def new
    @movementtype = current_user.movementtypes.new
  end

  # GET /movementtypes/1/edit
  def edit
  end

  # POST /movementtypes
  # POST /movementtypes.json
  def create
    @movementtype = current_user.movementtypes.new(movementtype_params)

    respond_to do |format|
      if @movementtype.save
        format.html { redirect_to @movementtype, notice: 'Movementtype was successfully created.' }
        format.json { render :show, status: :created, location: @movementtype }
      else
        format.html { render :new }
        format.json { render json: @movementtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movementtypes/1
  # PATCH/PUT /movementtypes/1.json
  def update
    respond_to do |format|
      if @movementtype.update(movementtype_params)
        format.html { redirect_to @movementtype, notice: 'Movementtype was successfully updated.' }
        format.json { render :show, status: :ok, location: @movementtype }
      else
        format.html { render :edit }
        format.json { render json: @movementtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movementtypes/1
  # DELETE /movementtypes/1.json
  def destroy
    @movementtype.destroy
    respond_to do |format|
      format.html { redirect_to movementtypes_url, notice: 'Movementtype was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movementtype
      @movementtype = Movementtype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movementtype_params
      params.require(:movementtype).permit(:name, :user_id)
    end
end
