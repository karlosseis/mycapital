class CompanyHistoricDividendsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_company
  before_action :set_company_historic_dividend, only: [:show, :edit, :update, :destroy]
  
  # GET /company_historic_dividends
  # GET /company_historic_dividends.json
  def index
    @company_historic_dividends = current_user.company_historic_dividends.order('payment_date DESC')
  end

  # GET /company_historic_dividends/1
  # GET /company_historic_dividends/1.json
  def show
  end

  # GET /company_historic_dividends/new
  def new
    parent = Company.find(params[:company_id])    
    @company_historic_dividend = parent.company_historic_dividends.new(dividend_type: 0)

  end

  # GET /company_historic_dividends/1/edit
  def edit
  end

  # POST /company_historic_dividends
  # POST /company_historic_dividends.json
  def create
    @company_historic_dividend = CompanyHistoricDividend.new(company_historic_dividend_params)
    @company_historic_dividend.company = @company
    respond_to do |format|
      @company_historic_dividend.user_id = current_user.id
      if @company_historic_dividend.save
        format.html { redirect_to @company_historic_dividend.company, notice: 'Company historic dividend was successfully created.' }
        format.json { render :show, status: :created, location: @company_historic_dividend }
      else
        format.html { render :new }
        format.json { render json: @company_historic_dividend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_historic_dividends/1
  # PATCH/PUT /company_historic_dividends/1.json
  def update
    respond_to do |format|
      if @company_historic_dividend.update(company_historic_dividend_params)
        format.html { redirect_to @company_historic_dividend.company, notice: 'Company historic dividend was successfully updated.' }
        format.json { render :show, status: :ok, location: @company_historic_dividend }
      else
        format.html { render :edit }
        format.json { render json: @company_historic_dividend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_historic_dividends/1
  # DELETE /company_historic_dividends/1.json
  def destroy
    @company_historic_dividend.destroy
    respond_to do |format|
      format.html { redirect_to @company_historic_dividend.company, notice: 'Company historic dividend was successfully destroyed.' }      
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_historic_dividend
      @company_historic_dividend = CompanyHistoricDividend.find(params[:id])
    end

   def set_company
      if params.has_key?(:company_id) then
        @company = Company.find(params[:company_id])   
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_historic_dividend_params
      params.require(:company_historic_dividend).permit(:exdividend_date, :record_date, :announce_date, :payment_date, :amount, :dividend_type, :company_id, :user_id, :retrieved_auto)
    end
end
