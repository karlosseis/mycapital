class TargetsController < ApplicationController
  def index


     if params[:only_open] == "N"
   
	    @greens = current_user.companies.verde
  	  @yellows = current_user.companies.amarillo
  	  @greys = current_user.companies.gris
      @oros = current_user.companies.oro

          
      #if params[:exclude_red] == "N"  
  	   @reds = current_user.companies.rojo
      #end

     else    	
  
   	   @greens = current_user.companies.joins(:stockexchange).where('stockexchanges.open_time <= ? and stockexchanges.close_time >= ? and traffic_light_id = ?' , Time.now, Time.now, Company.traffic_light_ids[:verde])
   	   @yellows = current_user.companies.joins(:stockexchange).where('stockexchanges.open_time <= ? and stockexchanges.close_time >= ? and traffic_light_id = ?' , Time.now, Time.now, Company.traffic_light_ids[:amarillo])
   	   @greys =current_user.companies.joins(:stockexchange).where('stockexchanges.open_time <= ? and stockexchanges.close_time >= ? and traffic_light_id = ?' , Time.now, Time.now, Company.traffic_light_ids[:gris])
       @oros =current_user.companies.joins(:stockexchange).where('stockexchanges.open_time <= ? and stockexchanges.close_time >= ? and traffic_light_id = ?' , Time.now, Time.now, Company.traffic_light_ids[:oro])
   	   
       #if params[:exclude_red] == "N"  
       @reds = current_user.companies.joins(:stockexchange).where('stockexchanges.open_time <= ? and stockexchanges.close_time >= ? and traffic_light_id = ?' , Time.now, Time.now, Company.traffic_light_ids[:rojo])
       #end
     end


  end
end
