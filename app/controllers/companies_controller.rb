class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  # GET /companies
  # GET /companies.json


  def index
    
    #@companies = current_user.companies.all
   
   if params[:searchbox]
      @companies = current_user.companies.search(params[:searchbox])

      respond_to do |format|

        if @companies.count == 1 then
          @company = Company.find(@companies[0].id)
          format.html { redirect_to @company }
        else

          format.html # index.html.erb
        end 
      end
    else
     @companies = current_user.companies.all
    end



  end

  def portfolio
    @companies = current_user.companies.where("shares_sum > ?", 0) 


  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    #@operation = Operation.new  

  end

  # GET /companies/new
  def new
    #byebug
    @company =  current_user.companies.new
  end

  # GET /companies/1/edit
  def edit
  #  unless params[:nombre_yahoo].nil?

      # no recibe el symbol
      # se queda como eidtando el id del ticker, p.ej el 1
      # luego graba bien, pero queda feo. Además, yo no creo que funcione si el usuaro no tiene visibilidad sobre la empresa 1


      
   #   @company =  current_user.companies.new(name: params[:nombre_yahoo], symbol: params[:ticker])
      #redirect_to new_company_path(@company)
       
    #end
  end

  # POST /companies
  # POST /companies.json
  def create
    #byebug
    @company =  current_user.companies.new(company_params)

    respond_to do |format|
      @company.set_update_summary
      @company.set_stock_price_google
      if  @company.save        
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @current_user.companies.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    #byebug
    respond_to do |format|
      @company.set_stock_price_google
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @current_user.companies.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    #byebug
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = current_user.companies.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :symbol, :stockexchange_id, :sector_id, :search_symbol, :user_id, :target_price_1,:target_price_2, :traffic_light_id, :investors_url, :target_sell_price, :dividend_aristocrat, :activity_description, :first_uninterrupted_year_div, :shares_quantity, :payout, :dividend_payments_quantity, :historic_dividend_url, :dividend_last_result, :next_exdividend_date, :next_dividend_date, :estimated_year_dividend_amount, :currency_symbol_operations, :estimated_value_operations_currency,:estimated_benefit_operations_currency, :perc_estimated_benefit_operations_currency, :puchased_sum_euros)
      
    end
  


end
