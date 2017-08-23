class MapconceptsController < ApplicationController
  before_action :set_mapconcept, only: [:show, :edit, :update, :destroy]

  # GET /mapconcepts
  # GET /mapconcepts.json
  def index
    @mapconcepts = Mapconcept.all
  end

  # GET /mapconcepts/1
  # GET /mapconcepts/1.json
  def show
  end

  # GET /mapconcepts/new
  def new
    @mapconcept = Mapconcept.new
  end

  # GET /mapconcepts/1/edit
  def edit
  end

  # POST /mapconcepts
  # POST /mapconcepts.json
  def create
    @mapconcept = Mapconcept.new(mapconcept_params)

    respond_to do |format|
      if @mapconcept.save
        format.html { redirect_to @mapconcept, notice: 'Mapconcept was successfully created.' }
        format.json { render :show, status: :created, location: @mapconcept }
      else
        format.html { render :new }
        format.json { render json: @mapconcept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mapconcepts/1
  # PATCH/PUT /mapconcepts/1.json
  def update
    respond_to do |format|
      if @mapconcept.update(mapconcept_params)
        format.html { redirect_to @mapconcept, notice: 'Mapconcept was successfully updated.' }
        format.json { render :show, status: :ok, location: @mapconcept }
      else
        format.html { render :edit }
        format.json { render json: @mapconcept.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mapconcepts/1
  # DELETE /mapconcepts/1.json
  def destroy
    @mapconcept.destroy
    respond_to do |format|
      format.html { redirect_to mapconcepts_url, notice: 'Mapconcept was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mapconcept
      @mapconcept = Mapconcept.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mapconcept_params
      params.require(:mapconcept).permit(:name, :subcategory_id, :user_id)
    end
end
