class YahooTickersController < ApplicationController
  before_action :set_yahoo_ticker, only: [:show, :edit, :update, :destroy]

  # GET /yahoo_tickers
  # GET /yahoo_tickers.json
  def index
    @yahoo_tickers = YahooTicker.all
  end

  def create_company
   Company.new(name: 'hola') 
   Company.save() 

  end




  # GET /yahoo_tickers/1
  # GET /yahoo_tickers/1.json
  def show
  end

  # GET /yahoo_tickers/new
  def new
    @yahoo_ticker = YahooTicker.new
  end

  # GET /yahoo_tickers/1/edit
  def edit
  end

  # POST /yahoo_tickers
  # POST /yahoo_tickers.json
  def create
    @yahoo_ticker = YahooTicker.new(yahoo_ticker_params)

    respond_to do |format|
      if @yahoo_ticker.save
        format.html { redirect_to @yahoo_ticker, notice: 'Yahoo ticker was successfully created.' }
        format.json { render :show, status: :created, location: @yahoo_ticker }
      else
        format.html { render :new }
        format.json { render json: @yahoo_ticker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /yahoo_tickers/1
  # PATCH/PUT /yahoo_tickers/1.json
  def update
    respond_to do |format|
      if @yahoo_ticker.update(yahoo_ticker_params)
        format.html { redirect_to @yahoo_ticker, notice: 'Yahoo ticker was successfully updated.' }
        format.json { render :show, status: :ok, location: @yahoo_ticker }
      else
        format.html { render :edit }
        format.json { render json: @yahoo_ticker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /yahoo_tickers/1
  # DELETE /yahoo_tickers/1.json
  def destroy
    @yahoo_ticker.destroy
    respond_to do |format|
      format.html { redirect_to yahoo_tickers_url, notice: 'Yahoo ticker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_yahoo_ticker
      @yahoo_ticker = YahooTicker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def yahoo_ticker_params
      params.require(:yahoo_ticker).permit(:ticker, :name, :exchange, :name_country, :category)
    end
end
