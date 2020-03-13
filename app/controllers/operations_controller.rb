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

    # Si el broker sólo trabaja en euros (ing), la moneda de la operación será EUROS y la origen (o a la que se quiere convertir)
    #   será la moneda de la empresa (dólares, euros, etc)
    unless parent.broker.nil?
      if parent.broker.only_euros    
        currency_operation_id =  Settings.stockexchange_currency_id["€"]
        currency_id = parent.stockexchange.currency_id
      else
        # sino, la moneda de la operación será la de la empresa (es en lo que cobramos/pagamos) y queremos convertir a euros.
        currency_operation_id =  parent.stockexchange.currency_id
        currency_id = Settings.stockexchange_currency_id["€"]

      end
    end

   if params[:operationtype_id].to_s == Mycapital::OP_DIVIDEND.to_s
     @operation = parent.operations.new(
            operationtype_id: params[:operationtype_id],
            quantity: parent.shares_sum,
            operation_date: Time.now.strftime('%d-%m-%Y'),
            currency_id: currency_id,
            broker_id: parent.broker_id
            
          )
    else

      @operation = parent.operations.new(
            operationtype_id: params[:operationtype_id],            
            operation_date: Time.now.strftime('%d-%m-%Y'),
            currency_operation_id: currency_operation_id,
            currency_id: currency_id,
            broker_id: parent.broker_id
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
    # 01.07.2018 - Si es un dividendo y sólo informan el total bruto y la retención en origen, 
    #              el sistema calculará automáticamente la retención en destino y el total neto. 
    #              Útil para dividendos de activo trade

    if @operation.operationtype_id == Mycapital::OP_DIVIDEND

        if @operation.net_amount.nil? and @operation.destination_tax.nil? and !@operation.gross_amount.nil? and !@operation.withholding_tax.nil?

          @operation.destination_tax = ((@operation.gross_amount - @operation.withholding_tax) * Country.find(Mycapital::ID_PAIS).perc_tax ) / 100
          @operation.net_amount = @operation.gross_amount - @operation.withholding_tax - @operation.destination_tax

        end

    end

  # 01.07.2018 - Si es una compra y no han informado el total en euros y el precio en euros de la acción 
  #              se calculan automáticamente si el usuario ha puesto la tasa de cambio

    if @operation.operationtype_id == Mycapital::OP_PURCHASE

        if @operation.origin_price.nil? and (@operation.puchased_sum_euros.nil? or @operation.puchased_sum_euros == 0) and !@operation.exchange_rate.nil?

          @operation.origin_price = @operation.price * @operation.exchange_rate 
          @operation.puchased_sum_euros = @operation.amount * @operation.exchange_rate 

        end

    end   
    
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
      params.require(:operation).permit(:company_id, :operationtype_id, :amount, :comments, :commission, :currency_id, :destination_tax, :exchange_rate, :fee, :gross_amount, :net_amount, :operation_date, :origin_price, :price, :quantity, :withholding_tax, :user_id, :broker_id, :currency_operation_id, :puchased_sum_euros, :tax_rate_auto, :earnings_sum, :earnings_sum_euros)
    end
end
