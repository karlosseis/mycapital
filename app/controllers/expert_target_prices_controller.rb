class ExpertTargetPricesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expert_target_price, only: [:show, :edit, :update, :destroy]
  before_action :set_company
  # GET /expert_target_prices
  # GET /expert_target_prices.json
  def index
    @expert_target_prices = current_user.expert_target_prices.order('date_target_price DESC').all            
  end

  # GET /expert_target_prices/1
  # GET /expert_target_prices/1.json
  def show
  end

  # GET /expert_target_prices/new
  def new
    #@expert_target_price = ExpertTargetPrice.new

    parent = Company.find(params[:company_id])
    @expert_target_price = parent.expert_target_prices.new(date_target_price: Time.now.strftime('%d-%m-%Y'))
    #@expert_target_price.date_target_price =  Time.now.strftime('%d-%m-%Y')
    #@expert_target_price = parent.expert_target_prices.new(date_target_price: Time.now.strftime('%d-%m-%Y'))


  end

  # GET /expert_target_prices/1/edit
  def edit
  end

  # POST /expert_target_prices
  # POST /expert_target_prices.json
  def create
    @expert_target_price = ExpertTargetPrice.new(expert_target_price_params)
    @expert_target_price.company = @company
    respond_to do |format|
      @expert_target_price.user_id = current_user.id
      if @expert_target_price.save
        format.html { redirect_to @expert_target_price.company, notice: 'Expert target price was successfully created.' }
        format.json { render :show, status: :created, location: @expert_target_price }
      else
        format.html { render :new }
        format.json { render json: @expert_target_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expert_target_prices/1
  # PATCH/PUT /expert_target_prices/1.json
  def update
    respond_to do |format|
      if @expert_target_price.update(expert_target_price_params)
        format.html { redirect_to @expert_target_price.company, notice: 'Expert target price was successfully updated.' }
        format.json { render :show, status: :ok, location: @expert_target_price }
      else
        format.html { render :edit }
        format.json { render json: @expert_target_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expert_target_prices/1
  # DELETE /expert_target_prices/1.json
  def destroy
    @expert_target_price.destroy
    respond_to do |format|
      format.html { redirect_to @expert_target_price.company, notice: 'Expert target price was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expert_target_price
      @expert_target_price = ExpertTargetPrice.find(params[:id])
    end

    def set_company
      if params.has_key?(:company_id) then
        @company = Company.find(params[:company_id])   
      end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def expert_target_price_params
      params.require(:expert_target_price).permit(:date_target_price, :target_price_1, :target_price_2, :reference_web_id, :url, :company_id)
    end
end
