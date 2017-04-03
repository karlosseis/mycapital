class ReferenceWebsController < ApplicationController
  before_action :set_reference_web, only: [:show, :edit, :update, :destroy]

  # GET /reference_webs
  # GET /reference_webs.json
  def index
    @reference_webs = current_user.reference_webs.all
  end

  # GET /reference_webs/1
  # GET /reference_webs/1.json
  def show
  end

  # GET /reference_webs/new
  def new
    @reference_web = current_user.reference_webs.new
  end

  # GET /reference_webs/1/edit
  def edit
  end

  # POST /reference_webs
  # POST /reference_webs.json
  def create
    @reference_web = current_user.reference_webs.new(reference_web_params)

    respond_to do |format|
      if @reference_web.save
        format.html { redirect_to @reference_web, notice: 'Reference web was successfully created.' }
        format.json { render :show, status: :created, location: @reference_web }
      else
        format.html { render :new }
        format.json { render json: @reference_web.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reference_webs/1
  # PATCH/PUT /reference_webs/1.json
  def update
    respond_to do |format|
      if @reference_web.update(reference_web_params)
        format.html { redirect_to @reference_web, notice: 'Reference web was successfully updated.' }
        format.json { render :show, status: :ok, location: @reference_web }
      else
        format.html { render :edit }
        format.json { render json: @reference_web.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reference_webs/1
  # DELETE /reference_webs/1.json
  def destroy
    @reference_web.destroy
    respond_to do |format|
      format.html { redirect_to reference_webs_url, notice: 'Reference web was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reference_web
      @reference_web = ReferenceWeb.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reference_web_params
      params.require(:reference_web).permit(:name, :url, :user_id)
    end
end
