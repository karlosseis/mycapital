class BalancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_balance, only: [:show, :edit, :update, :destroy]

  # GET /balances
  # GET /balances.json
  def index
    @balances = current_user.balances.order('balance_date DESC').all
    @graph_cash_data = current_user.balances.where('balance_date >= ?', (Time.now - 12.month).beginning_of_day).group_by_month(:balance_date, format: "%B-%Y").sum(:cash_sum)
    @graph_portfolio_data = current_user.balances.where('balance_date >= ?', (Time.now - 12.month).beginning_of_day).group_by_month(:balance_date, format: "%B-%Y").sum(:portfolio_sum)
    @graph_equity_data = current_user.balances.where('balance_date >= ?', (Time.now - 12.month).beginning_of_day).group_by_month(:balance_date, format: "%B-%Y").sum(:total_sum)
  end


  # GET /balances/1
  # GET /balances/1.json
  def show
  end

  # GET /balances/new
  # GET /balances/new
  def new
    @balance = current_user.balances.new(balance_date: Time.now.strftime('%d-%m-%Y'))

    # creo tantos registros de detalle como conceptos haya en la base de datos
    current_user.accounts.all.each do |cuenta|
       @balance.balance_details.build(:account_id => cuenta.id)
    end
  end

  # GET /balances/1/edit
  def edit
  end

  # POST /balances
  # POST /balances.json
  def create
    @balance = current_user.balances.new(balance_params)

    respond_to do |format|
      @balance.set_totals
      if @balance.save
        format.html { redirect_to balances_url, notice: 'Balance was successfully created.' }
        format.json { render :show, status: :created, location: @balance }
      else
        format.html { render :new }
        format.json { render json: @balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /balances/1
  # PATCH/PUT /balances/1.json
  def update
    respond_to do |format|
      if @balance.update(balance_params)
        format.html { redirect_to balances_url, notice: 'Balance was successfully updated.' }
        format.json { render :show, status: :ok, location: @balance }
      else
        format.html { render :edit }
        format.json { render json: @balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /balances/1
  # DELETE /balances/1.json
  def destroy
    @balance.destroy
    respond_to do |format|
      format.html { redirect_to balances_url, notice: 'Balance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_balance
      @balance = Balance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def balance_params
      params.require(:balance).permit(:name, :balance_date, :details, :user_id, balance_details_attributes: [ :id, :name, :amount, :account_id, :user_id ])
    end
end
