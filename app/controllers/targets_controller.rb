class TargetsController < ApplicationController
  def index


    if params[:only_open] == "Y"
     # @yahoo_tickers = YahooTicker.search(params[:search]).page(params[:page]).per(30)
   	  # @greens = current_user.companies.where(traffic_light_id: [:verde])

   	  @greens = Company.joins(:stockexchange).where('stockexchanges.open_time <= ? and stockexchanges.close_time >= ? and traffic_light_id = ?' , Time.now, Time.now, Company.traffic_light_ids[:verde])
   	  @yellows = Company.joins(:stockexchange).where('stockexchanges.open_time <= ? and stockexchanges.close_time >= ? and traffic_light_id = ?' , Time.now, Time.now, Company.traffic_light_ids[:amarillo])
   	  @greys =Company.joins(:stockexchange).where('stockexchanges.open_time <= ? and stockexchanges.close_time >= ? and traffic_light_id = ?' , Time.now, Time.now, Company.traffic_light_ids[:gris])
   	  @reds = Company.joins(:stockexchange).where('stockexchanges.open_time <= ? and stockexchanges.close_time >= ? and traffic_light_id = ?' , Time.now, Time.now, Company.traffic_light_ids[:rojo])
   	  #Company.where("traffic_light_id = ? and stockexchange_id = ? ", Company.traffic_light_ids[:verde], 1)
#Company.joins(:stockexchange).where(stockexchanges: { name: "M.CONTINUO" }, traffic_light_id: Company.traffic_light_ids[:verde])


#Company.joins(:stockexchange).where(stockexchanges: { id:  Stockexchange.all.ids }, traffic_light_id: Company.traffic_light_ids[:verde])


#Company.joins(:stockexchange).where(stockexchanges: { name: "M.CONTINUO" })


  	  @yellows = current_user.companies.amarillo
  	  @greys = current_user.companies.gris      
  	  @reds = current_user.companies.rojo      
    else    	
  	 @greens = current_user.companies.verde
  	 @yellows = current_user.companies.amarillo
  	 @greys = current_user.companies.gris
  	 @reds = current_user.companies.rojo
  
   
    end


  end
end
