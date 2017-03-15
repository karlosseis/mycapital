class BalanceDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_balance_detail, only: [:show, :edit, :update, :destroy]

  # GET /balance_details
  # GET /balance_details.json
  def index
    @balance_details = current_user.balance_details.all
  end

  # GET /balance_details/1
  # GET /balance_details/1.json
  def show
  end

  # GET /balance_details/new
  def new
    @balance_detail = current_user.balance_details.new
  end

  # GET /balance_details/1/edit
  def edit
  end

  # POST /balance_details
  # POST /balance_details.json
  def create
    @balance_detail = current_user.balance_details.new(balance_detail_params)

    respond_to do |format|
      if @balance_detail.save
        format.html { redirect_to @balance_detail.balance, notice: 'Balance detail was successfully created.' }
        format.json { render :show, status: :created, location: @balance_detail }
      else
        format.html { render :new }
        format.json { render json: @balance_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /balance_details/1
  # PATCH/PUT /balance_details/1.json
  def update
    respond_to do |format|
      if @balance_detail.update(balance_detail_params)
        format.html { redirect_to @balance_detail.balance, notice: 'Balance detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @balance_detail }
      else
        format.html { render :edit }
        format.json { render json: @balance_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /balance_details/1
  # DELETE /balance_details/1.json
  def destroy
    @balance_detail.destroy
    respond_to do |format|
      format.html { redirect_to balance_detail.balance, notice: 'Balance detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_balance_detail
      @balance_detail = BalanceDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def balance_detail_params
      params.require(:balance_detail).permit(:name, :amount, :balance_date, :balance_id, :account_id, :user_id)
    end
end
