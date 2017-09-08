class OperationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_operation, only: [:show, :edit, :update, :destroy]
  before_action :set_company
  #  before_action :set_operation_type
  # GET /operations
  # GET /operations.json
  def index
    @operations = current_user.operations.order(operation_date: :desc)
  end

  # GET /operations/1
  # GET /operations/1.json
  def show
  end

  # GET /operations/new
  def new
    #@operation = Operation.new(operation_params)
    parent = Company.find(params[:company_id])
    #k = parent.stockexchange.currency_id
    # @operation = parent.operations.create
    # @operation.operationtype_id = params[:operationtype_id]
    #@operation = parent.operations.new(operationtype_id: params[:operationtype_id], operation_date: Time.now)
   
   if params[:operationtype_id].to_s == Mycapital::OP_DIVIDEND.to_s
     @operation = parent.operations.new(
            operationtype_id: params[:operationtype_id],
            quantity: parent.shares_sum,
            operation_date: Time.now.strftime('%d-%m-%Y'),
            currency_id: parent.stockexchange.currency_id
            
          )
    else
      @operation = parent.operations.new(
            operationtype_id: params[:operationtype_id],            
            operation_date: Time.now.strftime('%d-%m-%Y'),
            currency_id: parent.stockexchange.currency_id
          )
  

    end


   
  end

  # GET /operations/1/edit
  def edit
  end

  # POST /operations
  # POST /operations.json
  def create
    
    @operation = Operation.new(operation_params)
    @operation.company = @company
    @operation.user_id = current_user.id
    respond_to do |format|
      if @operation.save
        format.html { redirect_to @operation.company, notice: 'Operation was successfully created.' }
        format.json { render :show, status: :created, location: @operation }
      else
        format.html { render :new }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operations/1
  # PATCH/PUT /operations/1.json
  def update
    respond_to do |format|
      if @operation.update(operation_params)
        format.html { redirect_to @operation.company, notice: 'Operation was successfully updated.' }
        format.json { render :show, status: :ok, location: @operation }
      else
        format.html { render :edit }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1
  # DELETE /operations/1.json
  def destroy
    @operation.destroy
    respond_to do |format|
      format.html { redirect_to @operation.company, notice: 'Operation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operation
      @operation = Operation.find(params[:id])
    end

    def set_company
      if params.has_key?(:company_id) then
        @company = Company.find(params[:company_id])   
      end
    end

 #     def set_operation_type
 #       @company = Company.find(params[:company_id])   
 #     end


    # Never trust parameters from the scary internet, only allow the white list through.
    def operation_params
      params.require(:operation).permit(:company_id, :operationtype_id, :amount, :comments, :commission, :currency_id, :destination_tax, :exchange_rate, :fee, :gross_amount, :net_amount, :operation_date, :origin_price, :price, :quantity, :withholding_tax, :user_id, :broker_id)
    end
end
