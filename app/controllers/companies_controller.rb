class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # GET /companies.json


  def index
    
    @companies = current_user.companies.all
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
      @company.set_stock_price
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
      @company.set_stock_price
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


  helper_method :total_dividend_sum   
  helper_method :total_puchased_sum
  helper_method :total_sold_sum
  helper_method :total_ampliated_sum
  helper_method :total_quantity_puchased
  helper_method :total_quantity_sold
  helper_method :total_quantity_ampliated  
  helper_method :total_shares_sum  
  helper_method :total_invested_sum

  helper_method :average_price
  helper_method :share_price_global_currency
  helper_method :estimated_value_global_currency 
  helper_method :estimated_benefit_global_currency
  helper_method :perc_estimated_benefit_global_currency



  def total_dividend_sum (comp)   
    total = comp.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND).sum(:net_amount)
    total.round(2)
  end

  def total_puchased_sum (comp)  
    total = comp.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).sum(:amount)
    total.round(2)
  end

  def total_sold_sum   (comp)  
      total = comp.operations.where(:operationtype_id => Mycapital::OP_SALE).sum(:amount)
      total.round(2)
  end

  def total_ampliated_sum   (comp)  
      total = comp.operations.where(:operationtype_id => Mycapital::OP_AMPLIATION).sum(:amount)
      total.round(2)
  end

  def total_quantity_puchased (comp)  
    total = comp.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).sum(:quantity)
    total
  end

  def total_quantity_sold  (comp)  
      total = comp.operations.where(:operationtype_id => Mycapital::OP_SALE).sum(:quantity)
      total
  end

  def total_quantity_ampliated  (comp)  
      total = comp.operations.where(:operationtype_id => Mycapital::OP_AMPLIATION).sum(:quantity)
      total
  end

  def total_shares_sum(comp)
    total_quantity_puchased(comp) - total_quantity_sold(comp) + total_quantity_ampliated(comp)
  end

  def total_invested_sum (comp)  
     total_puchased_sum(comp) - total_sold_sum(comp)
  end 

  def average_price (comp)  
     total = 0
     total_shares = total_shares_sum(comp)
     unless total_shares == 0
       total = total_invested_sum(comp) / total_shares
     end
     total.round(2)
  end

  def share_price_global_currency (comp)
    # share prices in currency purchases (ie, all the operations are bought in euros, 
    # the currency will be euros)
    if comp.stockexchange.currency.name ==  Mycapital::CURRENCY_PURCHASE then
       total = comp.share_price
    else
      require 'money'
      require 'money/bank/google_currency'      
      bank = Money::Bank::GoogleCurrency.new
      total = comp.share_price * bank.get_rate(comp.stockexchange.currency.name, Mycapital::CURRENCY_PURCHASE).to_f
    end
    total.round(2)
  end

  def estimated_value_global_currency (comp)
    total = share_price_global_currency(comp) * total_shares_sum(comp)
    total.round(2)
  end


  def estimated_benefit_global_currency  (comp)  
    total = estimated_value_global_currency(comp) - total_invested_sum(comp)
    total.round(2)
  end

  def perc_estimated_benefit_global_currency  (comp)  
    invested =  total_invested_sum(comp)
    total = 0
    unless invested == 0 then
        total = estimated_benefit_global_currency(comp) * 100 / total_invested_sum(comp)
    end
    total.round(2)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = current_user.companies.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :symbol, :stockexchange_id, :sector_id, :search_symbol, :user_id)
      #params.require(:company).permit(:name, :symbol, :stockexchange_id, :sector_id, :dividend_sum, :puchased_sum, :sold_sum, :ampliated_sum, :quantity_puchased, :quantity_sold, :quantity_ampliated, :shares_sum, :invested_sum, :average_price, :share_price_global_currency, :estimated_value_global_currency, :estimated_benefit_global_currency, :perc_estimated_benefit_global_currency, :date_share_price, :average_price_origin_currency_real, :average_price_real)
    end
end
