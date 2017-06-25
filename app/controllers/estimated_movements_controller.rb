class EstimatedMovementsController < ApplicationController
  before_action :set_estimated_movement, only: [:show, :edit, :update, :destroy]

  # GET /estimated_movements
  # GET /estimated_movements.json
  def index
    @estimated_movements = current_user.estimated_movements.all
  end

  # GET /estimated_movements/1
  # GET /estimated_movements/1.json
  def show
  end

  # GET /estimated_movements/new
  def new
    @estimated_movement = current_user.estimated_movements.new
  end

  # GET /estimated_movements/1/edit
  def edit
  end

  # POST /estimated_movements
  # POST /estimated_movements.json
  def create
    @estimated_movement = current_user.estimated_movements.new(estimated_movement_params)

    respond_to do |format|
      if @estimated_movement.save
        format.html { redirect_to @estimated_movement, notice: 'Estimated movement was successfully created.' }
        format.json { render :show, status: :created, location: @estimated_movement }
      else
        format.html { render :new }
        format.json { render json: @estimated_movement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /estimated_movements/1
  # PATCH/PUT /estimated_movements/1.json
  def update
    respond_to do |format|
      if @estimated_movement.update(estimated_movement_params)
        format.html { redirect_to @estimated_movement, notice: 'Estimated movement was successfully updated.' }
        format.json { render :show, status: :ok, location: @estimated_movement }
      else
        format.html { render :edit }
        format.json { render json: @estimated_movement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estimated_movements/1
  # DELETE /estimated_movements/1.json
  def destroy
    @estimated_movement.destroy
    respond_to do |format|
      format.html { redirect_to estimated_movements_url, notice: 'Estimated movement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_estimated_movement
      @estimated_movement = EstimatedMovement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def estimated_movement_params
      params.require(:estimated_movement).permit(:name, :amount, :movement_date, :subcategory_id, :movementtype_id, :account_id, :month_number, :user_id, :account_name)
    end
end
