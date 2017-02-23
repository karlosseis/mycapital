class StockexchangesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stockexchange, only: [:show, :edit, :update, :destroy]

  # GET /stockexchanges
  # GET /stockexchanges.json
  def index
    @stockexchanges = Stockexchange.all
  end

  # GET /stockexchanges/1
  # GET /stockexchanges/1.json
  def show
  end

  # GET /stockexchanges/new
  def new
    @stockexchange = Stockexchange.new
  end

  # GET /stockexchanges/1/edit
  def edit
  end

  # POST /stockexchanges
  # POST /stockexchanges.json
  def create
    @stockexchange = Stockexchange.new(stockexchange_params)

    respond_to do |format|
      if @stockexchange.save
        format.html { redirect_to @stockexchange, notice: 'Stockexchange was successfully created.' }
        format.json { render :show, status: :created, location: @stockexchange }
      else
        format.html { render :new }
        format.json { render json: @stockexchange.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stockexchanges/1
  # PATCH/PUT /stockexchanges/1.json
  def update
    respond_to do |format|
      if @stockexchange.update(stockexchange_params)
        format.html { redirect_to @stockexchange, notice: 'Stockexchange was successfully updated.' }
        format.json { render :show, status: :ok, location: @stockexchange }
      else
        format.html { render :edit }
        format.json { render json: @stockexchange.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stockexchanges/1
  # DELETE /stockexchanges/1.json
  def destroy
    @stockexchange.destroy
    respond_to do |format|
      format.html { redirect_to stockexchanges_url, notice: 'Stockexchange was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stockexchange
      @stockexchange = Stockexchange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stockexchange_params
      params.require(:stockexchange).permit(:name, :country_id)
    end
end
