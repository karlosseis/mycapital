class CompanyResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_company_result, only: [:show, :edit, :update, :destroy]

  # GET /company_results
  # GET /company_results.json
  def index
    @company_results = current_user.company_results.order('year_result DESC').all  
  end

  # GET /company_results/1
  # GET /company_results/1.json
  def show
  end

  # GET /company_results/new
  def new
    parent = Company.find(params[:company_id])
    @company_result = parent.company_results.new(fecha_resultado: Time.now.strftime('%d-%m-%Y'), year_result: (Time.now - 1.year).end_of_year.strftime('%d-%m-%Y') )   
  end

  # GET /company_results/1/edit
  def edit
  end

  # POST /company_results
  # POST /company_results.json
  def create
    @company_result = CompanyResult.new(company_result_params)
    @company_result.company = @company
    @company_result.user_id = current_user.id
    respond_to do |format|
      if @company_result.save
        format.html { redirect_to @company_result.company, notice: 'Company result was successfully created.' }
        format.json { render :show, status: :created, location: @company_result }
      else
        format.html { render :new }
        format.json { render json: @company_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_results/1
  # PATCH/PUT /company_results/1.json
  def update
    respond_to do |format|
      if @company_result.update(company_result_params)
        format.html { redirect_to @company_result.company, notice: 'Company result was successfully updated.' }
        format.json { render :show, status: :ok, location: @company_result }
      else
        format.html { render :edit }
        format.json { render json: @company_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_results/1
  # DELETE /company_results/1.json
  def destroy
    @company_result.destroy
    respond_to do |format|
      format.html { redirect_to @company_result.company, notice: 'Company result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_result
      @company_result = CompanyResult.find(params[:id])
    end

    def set_company
      if params.has_key?(:company_id) then
        @company = Company.find(params[:company_id])   
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_result_params
      params.require(:company_result).permit(:fecha_resultado, :es_oficial, :cotizacion, :cotiz_max, :cotiz_min, :patrimonio_neto, :gastos_generales, :gastos_desarrollo, :ventas, :ebitda, :ebit, :beneficio_neto_ordinario, :beneficion_neto_total, :deuda_largo_plazo, :deuda_corto_plazo, :deuda_neta, :cf_explotacion, :cf_inversion, :cf_financiacion, :cf_neto, :dividendo_ordinario, :dividendo_extraordinario, :dividendo_total, :num_acciones, :bpa, :payout, :pago_dividendos, :per_max, :per_med, :per_min, :year_result, :comment, :company_id, :user_id)
    end
end
