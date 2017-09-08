class ExpectedDividendsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expected_dividend, only: [:show, :edit, :update, :destroy]

  # GET /expected_dividends
  # GET /expected_dividends.json
  def index
    #@expected_dividends = ExpectedDividend.all
    @expected_dividends = current_user.expected_dividends.order(operation_date: :desc)
  end

  # GET /expected_dividends/1
  # GET /expected_dividends/1.json
  def show
  end

  # GET /expected_dividends/new
  def new
    @expected_dividend = ExpectedDividend.new
  end

  # GET /expected_dividends/1/edit
  def edit
  end

  # POST /expected_dividends
  # POST /expected_dividends.json
  def create
    @expected_dividend = ExpectedDividend.new(expected_dividend_params)

    respond_to do |format|
      if @expected_dividend.save
        format.html { redirect_to @expected_dividend, notice: 'Expected dividend was successfully created.' }
        format.json { render :show, status: :created, location: @expected_dividend }
      else
        format.html { render :new }
        format.json { render json: @expected_dividend.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expected_dividends/1
  # PATCH/PUT /expected_dividends/1.json
  def update
    respond_to do |format|
      if @expected_dividend.update(expected_dividend_params)
        format.html { redirect_to @expected_dividend, notice: 'Expected dividend was successfully updated.' }
        format.json { render :show, status: :ok, location: @expected_dividend }
      else
        format.html { render :edit }
        format.json { render json: @expected_dividend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expected_dividends/1
  # DELETE /expected_dividends/1.json
  def destroy
    @expected_dividend.destroy
    respond_to do |format|
      format.html { redirect_to expected_dividends_url, notice: 'Expected dividend was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expected_dividend
      @expected_dividend = ExpectedDividend.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expected_dividend_params
      params.require(:expected_dividend).permit(:company_id, :operationtype_id, :operation_date, :quantity, :price_unit, :amount, :currency_id, :origin_price, :origin_price_unit, :origin_amount, :user_id)
    end
end
