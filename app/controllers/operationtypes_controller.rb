class OperationtypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_operationtype, only: [:show, :edit, :update, :destroy]

  # GET /operationtypes
  # GET /operationtypes.json
  def index
    @operationtypes = Operationtype.all
  end

  # GET /operationtypes/1
  # GET /operationtypes/1.json
  def show
  end

  # GET /operationtypes/new
  def new
    @operationtype = Operationtype.new
  end

  # GET /operationtypes/1/edit
  def edit
  end

  # POST /operationtypes
  # POST /operationtypes.json
  def create
    @operationtype = Operationtype.new(operationtype_params)

    respond_to do |format|
      if @operationtype.save
        format.html { redirect_to @operationtype, notice: 'Operationtype was successfully created.' }
        format.json { render :show, status: :created, location: @operationtype }
      else
        format.html { render :new }
        format.json { render json: @operationtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operationtypes/1
  # PATCH/PUT /operationtypes/1.json
  def update
    respond_to do |format|
      if @operationtype.update(operationtype_params)
        format.html { redirect_to @operationtype, notice: 'Operationtype was successfully updated.' }
        format.json { render :show, status: :ok, location: @operationtype }
      else
        format.html { render :edit }
        format.json { render json: @operationtype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operationtypes/1
  # DELETE /operationtypes/1.json
  def destroy
    @operationtype.destroy
    respond_to do |format|
      format.html { redirect_to operationtypes_url, notice: 'Operationtype was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operationtype
      @operationtype = Operationtype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operationtype_params
      params.require(:operationtype).permit(:name)
    end
end
