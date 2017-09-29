class MovementsController < ApplicationController
  before_action :set_movement, only: [:show, :edit, :update, :destroy]

  # GET /movements
  # GET /movements.json
  def index
    #@movements = current_user.movements.all
    if params[:filter_month]   
      @ini_mes = (Time.now.year.to_s + "-" + params[:filter_month] + "-01").to_date
    else
      @ini_mes = (Time.now.year.to_s + "-" + Time.now.month.to_s + "-01").to_date
    end
  
    # todos los movimientos del mes
    @movements = current_user.movements.where('movement_date >= ? and movement_date <= ?', @ini_mes, @ini_mes.end_of_month).order(:movement_date)

  end

  def index_month
   

   # Movimientos del mes

 
end
 
  # GET /movements/1
  # GET /movements/1.json
  def show
  end

  # GET /movements/new
  def new
    @movement = current_user.movements.new(movement_date: Time.now.strftime('%d-%m-%Y'))
  end

  # GET /movements/1/edit
  def edit
  end

  # POST /movements
  # POST /movements.json
  def create
    @movement = current_user.movements.new(movement_params)

    respond_to do |format|
      if @movement.save
        format.html { redirect_to movements_url, notice: 'Movement was successfully created.' }
        format.json { render :show, status: :created, location: @movement }
      else
        format.html { render :new }
        format.json { render json: @movement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movements/1
  # PATCH/PUT /movements/1.json
  def update
    respond_to do |format|
      if @movement.update(movement_params)
        format.html { redirect_to movements_url, notice: 'Movement was successfully updated.' }
        format.json { render :show, status: :ok, location: @movement }
      else
        format.html { render :edit }
        format.json { render json: @movement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movements/1
  # DELETE /movements/1.json
  def destroy
    @movement.destroy
    respond_to do |format|
      format.html { redirect_to movements_url, notice: 'Movement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movement
      @movement = Movement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movement_params
      params.require(:movement).permit(:name, :amount, :movement_date, :subcategory_id, :movementtype_id, :account_id, :location_id, :user_id)
    end
end
