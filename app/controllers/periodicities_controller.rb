class PeriodicitiesController < ApplicationController
  before_action :set_periodicity, only: [:show, :edit, :update, :destroy]

  # GET /periodicities
  # GET /periodicities.json
  def index
    @periodicities = current_user.periodicities.all
  end

  # GET /periodicities/1
  # GET /periodicities/1.json
  def show
  end

  # GET /periodicities/new
  def new
    @periodicity = current_user.periodicities.new
  end

  # GET /periodicities/1/edit
  def edit
  end

  # POST /periodicities
  # POST /periodicities.json
  def create
    @periodicity = current_user.periodicities.new(periodicity_params)

    respond_to do |format|
      if @periodicity.save
        format.html { redirect_to @periodicity, notice: 'Periodicity was successfully created.' }
        format.json { render :show, status: :created, location: @periodicity }
      else
        format.html { render :new }
        format.json { render json: @periodicity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /periodicities/1
  # PATCH/PUT /periodicities/1.json
  def update
    respond_to do |format|
      if @periodicity.update(periodicity_params)
        format.html { redirect_to @periodicity, notice: 'Periodicity was successfully updated.' }
        format.json { render :show, status: :ok, location: @periodicity }
      else
        format.html { render :edit }
        format.json { render json: @periodicity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /periodicities/1
  # DELETE /periodicities/1.json
  def destroy
    @periodicity.destroy
    respond_to do |format|
      format.html { redirect_to periodicities_url, notice: 'Periodicity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_periodicity
      @periodicity = Periodicity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def periodicity_params
      params.require(:periodicity).permit(:name, :num_months, :user_id)
    end
end
