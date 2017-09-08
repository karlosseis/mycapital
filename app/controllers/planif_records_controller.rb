class PlanifRecordsController < ApplicationController
  before_action :set_planif_record, only: [:show, :edit, :update, :destroy]

  # GET /planif_records
  # GET /planif_records.json
  def index
    @planif_records = current_user.planif_records.all
  end

  # GET /planif_records/1
  # GET /planif_records/1.json
  def show
  end

  # GET /planif_records/new
  def new
    @planif_record = current_user.planif_records.new(start_at: Time.now.strftime('%d-%m-%Y'))
  end

  # GET /planif_records/1/edit
  def edit
  end

  # POST /planif_records
  # POST /planif_records.json
  def create
    @planif_record = current_user.planif_records.new(planif_record_params)

    respond_to do |format|
      if @planif_record.save
        format.html { redirect_to planif_records_path, notice: 'Planif record was successfully created.' }
        format.json { render :show, status: :created, location: @planif_record }
      else
        format.html { render :new }
        format.json { render json: @planif_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /planif_records/1
  # PATCH/PUT /planif_records/1.json
  def update
    respond_to do |format|
      if @planif_record.update(planif_record_params)
        format.html { redirect_to planif_records_path, notice: 'Planif record was successfully updated.' }
        format.json { render :show, status: :ok, location: @planif_record }
      else
        format.html { render :edit }
        format.json { render json: @planif_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /planif_records/1
  # DELETE /planif_records/1.json
  def destroy
    @planif_record.destroy
    respond_to do |format|
      format.html { redirect_to planif_records_url, notice: 'Planif record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_planif_record
      @planif_record = PlanifRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def planif_record_params
      params.require(:planif_record).permit(:name, :amount, :day, :start_month, :start_at, :end_at, :subcategory_id, :account_id, :periodicity_id, :user_id)
    end
end
