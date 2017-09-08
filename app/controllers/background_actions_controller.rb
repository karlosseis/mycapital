class BackgroundActionsController < ApplicationController
  before_action :authenticate_user!
  def create_company
  	#redirect_to root_url, notice: 'Empresa creada'


  	#@company =  current_user.companies.new(name: params[:nombre_yahoo], symbol: params[:ticker])

#yahoo_name


	comp = current_user.companies.where('search_symbol = ?',params[:yahoo_ticker] )

	if comp.empty?
	  # si no existe la creamos
	  #redirect_to edit_company_path(comp)

	  symbol =  params[:yahoo_ticker]
	  exchange = params[:yahoo_exchange]
	  if exchange ==  "MCE"
	  	stock = Stockexchange.find_by_name("M.CONTINUO")
	  else
	  	stock = Stockexchange.find_by_name("NYSE")
	  end
	  
	  search_symbol = symbol
	  symbol = symbol.gsub( ".MC", "")
	  @company =  current_user.companies.new(name: params[:yahoo_name], symbol: symbol, search_symbol: search_symbol, stockexchange: stock)
	  @company.save!
	  redirect_to edit_company_path(@company)

	  
	else
		redirect_to yahoo_tickers_path, notice: 'La empresa seleccionada ya existe'
	end

  	
  end
end

