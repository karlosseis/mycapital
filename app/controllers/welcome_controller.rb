class WelcomeController < ApplicationController
  def index
     @todas = current_user.companies.all
     
     @stars = {}
     @to_sell = {}
     @max_subidas  = {}
     @max_bajadas  = {}
     @por_revisar_div = {}

     current_user.companies.all.each do |company| 

      if company.porc_dif_target_price.to_f <= 1 and company.target_price_1 > 0
        @stars[company.id] = company      
      end
  
      if company.porc_dif_target_sell_price.to_f <= 5 and company.target_sell_price > 0
        @to_sell[company.id] = company      
      end


      if company.var_percent.to_f > 4 
        @max_subidas[company.id] = company      
      end


      if company.var_percent.to_f <= -4 
        @max_bajadas[company.id] = company      
      end


      if company.next_dividend_date.nil? or company.next_dividend_date < Date.today
        @por_revisar_div[company.id] = company      
      end

     end
  end
end
