class WelcomeController < ApplicationController
  def index

    if current_user

     #@todas = current_user.companies.all
     
     @stars = {}
     @to_sell = {}  # acciones cuyo precio de venta se acerca al establecido 
     @max_subidas  = {} # acciones con subidas superiores al 4%
     @max_bajadas  = {}  # acciones con bajadas superiores al 4%
     @por_revisar_div = {}
     @prox_record_date = {}

     @next_dates_to_buy  = {}  # fechas límite por boker para comprar



     current_user.companies.all.each do |company| 

      unless company.porc_dif_target_price.nil? or company.target_price_1.nil?
	      if company.porc_dif_target_price.to_f <= 1 and company.target_price_1 > 0 and !company.rojo?
	        @stars[company.id] = company      
	      end      	
      end



  	  unless company.porc_dif_target_sell_price.nil? or company.target_sell_price.nil?	
	      if company.porc_dif_target_sell_price.to_f <= 5 and company.target_sell_price > 0
	        @to_sell[company.id] = company      
	      end
	    end

      if company.var_percent.to_f > 4 
        @max_subidas[company.id] = company      
      end


      if company.var_percent.to_f <= -4 
        @max_bajadas[company.id] = company      
      end



      # if company.next_dividend_date.nil? or company.next_dividend_date < Date.today
      #   @por_revisar_div[company.id] = company      
      # end


      unless company.rojo? # si es roja no quiero que me salga para actualziar dividendos ni para comprar
        #if company.next_dividend_date.nil? or company.next_dividend_date < Date.today
        # if  company.pendiente_incluir_dividendo_previsto?
        #     @por_revisar_div[company.id] = company      

        # end
        unless company.porc_dif_target_price.nil? or company.target_price_1.nil?
          if company.porc_dif_target_price.to_f <= 1 and company.target_price_1 > 0
            @stars[company.id] = company      
          end       
        end        
      end

     end

     current_user.brokers.all.each do |broker|

        op = broker.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).order(operation_date: :desc).limit(1)
        if op.count() == 1 
            @next_dates_to_buy[broker.name] = op[0].operation_date + broker.buy_frequency
        end
     end

    end

  end
end
