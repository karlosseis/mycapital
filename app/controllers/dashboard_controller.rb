class DashboardController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  def index
    
    # valor estimado en las diferentes monedas de las operaciones
    @global_value_currencies = current_user.companies.group(:currency_symbol_operations).sum(:estimated_value_operations_currency)
    

    # valor estimado en euros (convertimos todas las monedas a euros)  
    @global_value = 0
    @global_benefit = 0

    @global_value_currencies.each  do |key, value|  
      c = Currency.find_by(symbol: key)      
      unless c.nil?
        @global_value = @global_value + convert_to_eur(value, c.name) 
      end
    end 

    ## ---  
    # 14.02.2018 
    # Antes cogía el total en la moneda que fuera y lo pasaba a euros. Esto no funcionaba para las empresas migradas de ING a 
    #  activotrade
    # Ahoro cojo el campo que guarda los beneficios reales en euros.
    #@global_benefit_currencies = current_user.companies.group(:currency_symbol_operations).sum(:estimated_benefit_operations_currency)
    #@global_benefit_currencies.each  do |key, value|  
    #  c = Currency.find_by(symbol: key)      
    #  unless c.nil?
    #    @global_benefit = @global_benefit + convert_to_eur(value, c.name) 
    #  end
    #end 

    @global_benefit = current_user.companies.sum(:estimated_benefit_operations_currency_euros).round(2)
    ## --- 


    @global_value_currencies.delete(nil) # si viene alguna moneda a nulo la borro porque sino peta la búsqueda de la moneda.
    @global_value_currencies.delete('') # si viene alguna moneda a nulo la borro porque sino peta la búsqueda de la moneda.
    # convierto los símbolos de moneda en el id que le corresponde para poder ordenarlas y que salgan primero EUROS
    @global_value_currencies = @global_value_currencies.transform_keys{ |key| Currency.find_by(symbol: key.to_s).id  }
    @global_value_currencies = @global_value_currencies.sort


    # @global_invested = current_user.companies.sum(:invested_sum).round(2)
    # @global_perc_benefit = 0
    # unless @global_invested.to_f == 0 then
    #   @global_perc_benefit = @global_benefit.to_f * 100 / @global_invested.to_f
    # end
    # @global_perc_benefit.round(2)
  

  
    @last_purchases = current_user.operations.where(operationtype_id: Mycapital::OP_PURCHASE).order(operation_date: :desc).limit(3)    
    @next_dividends= current_user.expected_dividends.where('operationtype_id = ? and operation_date >= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_day).order(operation_date: :asc).limit(3)    
    
    @purchases_current_year_currencies= current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_PURCHASE, Time.now.beginning_of_year,Time.now.end_of_year).group(:currency_operation_id).sum(:amount)
    

    @purchases_current_year = 0
    @purchases_current_year_currencies.each  do |key, value|              
        @purchases_current_year = @purchases_current_year + convert_to_eur(value, Currency.find(key).name)       
    end 


    @dividends_current_year= current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_year,Time.now.end_of_year).group(:currency_id).sum(:net_amount)
    @dividends_current_month= current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_month,Time.now.end_of_month).group(:currency_id).sum(:net_amount)
    @expected_dividends_current_year= current_user.expected_dividends.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_year,Time.now.end_of_year).group(:currency_id).sum(:amount)

    # calculamos el total de dividendos en euro. Es decir, convertimos el total de cada moneda a euro
    @dividends_current_year_eur = 0
    @dividends_current_year.each  do |key, value|        
        @dividends_current_year_eur = @dividends_current_year_eur + convert_to_eur(value, Currency.find(key).name) 
    end 

    @dividends_current_month_eur = 0
    @dividends_current_month.each  do |key, value|        
        @dividends_current_month_eur = @dividends_current_month_eur + convert_to_eur(value, Currency.find(key).name) 
    end 

    @expected_dividends_current_year_eur = 0
    @expected_dividends_current_year.each  do |key, value|        
        @expected_dividends_current_year_eur = @expected_dividends_current_year_eur + convert_to_eur(value, Currency.find(key).name) 
    end 

 

    # Para gráficos

    @expected_dividends_group_month_array = {}
    @real_dividends_group_month_array = {}
    Currency.all.each do |curr|
      @expected_dividends_group_month_array[curr.id] = current_user.expected_dividends.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => curr.id).group_by_month(:operation_date).sum(:amount)
      @real_dividends_group_month_array[curr.id] = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, curr.id).group_by_month(:operation_date).sum(:net_amount)
    end

    @expected_dividends_group_month = current_user.expected_dividends.where(:operationtype_id => Mycapital::OP_DIVIDEND).group_by_month(:operation_date).sum(:amount)
    @real_dividends_group_month = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year).group_by_month(:operation_date).sum(:net_amount)
    

    # valor de las compras en cada una de las monedas 
    @purchases_group_year_eur = current_user.operations.where(:operationtype_id => Mycapital::OP_PURCHASE, :currency_operation_id => Currency.find_by_name("EUR")).group_by_year(:operation_date, format: "%Y").sum(:amount)
    @purchases_group_year_usd = current_user.operations.where(:operationtype_id => Mycapital::OP_PURCHASE, :currency_operation_id => Currency.find_by_name("USD")).group_by_year(:operation_date, format: "%Y").sum(:amount)
    @purchases_group_year_gbp = current_user.operations.where(:operationtype_id => Mycapital::OP_PURCHASE, :currency_operation_id => Currency.find_by_name("GBP")).group_by_year(:operation_date, format: "%Y").sum(:amount)

    # 23.02.2018 - valor de las compras y ventas en euros, conviertiendo las de moneda extranjera a euros
    @all_purchases_group_year_eur = current_user.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).group_by_year(:operation_date, format: "%Y").sum(:puchased_sum_euros)
    @all_sales_group_year_eur = current_user.operations.where(:operationtype_id => Mycapital::OP_SALE, :currency_operation_id => Currency.find_by_name("EUR")).group_by_year(:operation_date, format: "%Y").sum(:amount)
    @all_sales_group_year_usd = current_user.operations.where(:operationtype_id => Mycapital::OP_SALE, :currency_operation_id => Currency.find_by_name("USD")).group_by_year(:operation_date, format: "%Y").sum(:amount)
    @all_sales_group_year_gbp = current_user.operations.where(:operationtype_id => Mycapital::OP_SALE, :currency_operation_id => Currency.find_by_name("GBP")).group_by_year(:operation_date, format: "%Y").sum(:amount)
   


    @real_dividends_group_year_eur=  current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("EUR")).group_by_year(:operation_date, format: "%Y").sum(:net_amount)
    @real_dividends_group_year_usd=  current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("USD")).group_by_year(:operation_date, format: "%Y").sum(:net_amount)
    @real_dividends_group_year_gbp=  current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("GBP")).group_by_year(:operation_date, format: "%Y").sum(:net_amount)

    
    #@expected_dividends_group_company=   current_user.expected_dividends.group(:company).sum(:amount)

   @operations_benefit_euros = current_user.companies.where(:currency_symbol_operations => "€").sum(:earnings_sum).round(2)
   @operations_benefit_usd = current_user.companies.where(:currency_symbol_operations =>  "$").sum(:earnings_sum).round(2)
   @operations_benefit_gbp = current_user.companies.where(:currency_symbol_operations =>  "£").sum(:earnings_sum).round(2)


    @gross_dividend_group_year_eur = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, Currency.find_by_name("EUR")).sum(:gross_amount)
    @gross_dividend_group_year_usd = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, Currency.find_by_name("USD")).sum(:gross_amount)
    @gross_dividend_group_year_gbp = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, Currency.find_by_name("GBP")).sum(:gross_amount)




    @withholding_tax_dividend_group_year_eur = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, Currency.find_by_name("EUR")).sum(:withholding_tax)
    @withholding_tax_dividend_group_year_usd = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, Currency.find_by_name("USD")).sum(:withholding_tax)
    @withholding_tax_dividend_group_year_gbp = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, Currency.find_by_name("GBP")).sum(:withholding_tax)


    @destination_tax_dividend_group_year_eur = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, Currency.find_by_name("EUR")).sum(:destination_tax)
    @destination_tax_dividend_group_year_usd = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, Currency.find_by_name("USD")).sum(:destination_tax)
    @destination_tax_dividend_group_year_gbp = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ? and currency_id = ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year, Currency.find_by_name("GBP")).sum(:destination_tax)


    # Esto serviría si queremos mostrar todos los años, quedaría así:
    #{"2012"=>1.7699999809265137, "2013"=>10.370000123977661, "2014"=>357.51000225543976, "2015"=>978.3099985122681, "2016"=>1940.312987267971, "2017"=>2600.1099882125854, "2018"=>1268.3200149536133} € 
    #{"2017"=>136.44999980926514, "2018"=>900.3999934196472} $ 
    #{"2017"=>97.5, "2018"=>194.28000259399414} £ 

    # @gross_dividend_group_year_eur = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("EUR")).group_by_year(:operation_date, format: "%Y").sum(:gross_amount)
    # @gross_dividend_group_year_usd = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("USD")).group_by_year(:operation_date, format: "%Y").sum(:gross_amount)
    # @gross_dividend_group_year_gbp = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("GBP")).group_by_year(:operation_date, format: "%Y").sum(:gross_amount)

    # @withholding_tax_dividend_group_year_eur = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("EUR")).group_by_year(:operation_date, format: "%Y").sum(:withholding_tax)
    # @withholding_tax_dividend_group_year_usd = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("USD")).group_by_year(:operation_date, format: "%Y").sum(:withholding_tax)
    # @withholding_tax_dividend_group_year_gbp = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("GBP")).group_by_year(:operation_date, format: "%Y").sum(:withholding_tax)


    # @destination_tax_dividend_group_year_eur = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("EUR")).group_by_year(:operation_date, format: "%Y").sum(:destination_tax)
    # @destination_tax_dividend_group_year_usd = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("USD")).group_by_year(:operation_date, format: "%Y").sum(:destination_tax)
    # @destination_tax_dividend_group_year_gbp = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => Currency.find_by_name("GBP")).group_by_year(:operation_date, format: "%Y").sum(:destination_tax)



  end

  

  def index_historic_dividend

    # 25.09.2017 - No actualizado para tener en cuenta dividendos en moneda extranjera. Se incluirá en PowerBI

    # Buscamos todos los dividendos
    opers = current_user.operations.select(:company_id, :operation_date, :net_amount).where(:operationtype_id => Mycapital::OP_DIVIDEND).order('operation_date').group_by { |u| u.operation_date.beginning_of_month }
    
    # Extraemos los años que hemos tenido dividendos para poder montar una matriz con ellos y saber las columnas de la tabla
    @years = current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND).group_by_year(:operation_date).sum(:amount)

    # Averiguamos cuál es el año más pequeño. Esto servirá para restarlo en el vector y que no queden tantas posiciones en blanco. 
    # P.ej, si ponemos @meses[2016], se crean todas las posiciones hasta 2016. 
    #  si ponemos @meses[2016 - @year_min] (suponiendo que @year_min = 2015), sólo se creará la posición 0 y 1
    @year_min = 0 
    @year_max = 0 
    @years.each do |key, value|      
      if @year_min == 0  then  
        @year_min = key.year  
      end 
      if key.year > @year_max then
        @year_max = key.year  
      end

    end 

    comp_array = {}

    comp = current_user.companies.all

    comp.each do |c| 
        comp_array[c.id] = c.name
    
    end 

    @meses = []  

    opers.each do |key, value|  
      year_array = key.year - @year_min  
      value.each do |op|   
        years_company = [] 
        if @meses[key.month].nil? then     
          years_company[year_array] = op.net_amount 
          @meses[key.month] = {comp_array[op.company_id] => years_company} 
        else 
          empresas_mes =  @meses[key.month]      
          if empresas_mes[comp_array[op.company_id]].nil? then 
            # Primer registro de la empresa en el mes, lo añadimos 
            years_company[year_array] = op.net_amount 
            @meses[key.month].merge!(comp_array[op.company_id] => years_company) 
          else 
            # la empresa tiene registro en el mes pero quizá no en el año. Lo validamos. 
            years_company = empresas_mes[comp_array[op.company_id]] 
            if years_company[year_array].nil? then 
              years_company[year_array] = op.net_amount 
            else 
              years_company[year_array] = years_company[year_array] + op.net_amount 
            end 
            @meses[key.month].merge!(comp_array[op.company_id] => years_company) 
          end 
        end 
      end
    end 

   
   # Calculamos el total de cada mes y el anual global
   @meses_totales = []
   @years_totales = @years.clone

    @years_totales.each do |key, value|        
         @years_totales[key] = 0 
    end   


   [1,2,3,4,5,6,7,8,9,10,11,12].each do |num_mes|  
   
         @years.each do |key, value|
             @years[key] = 0            
         end           
          unless @meses[num_mes].nil?
           @meses[num_mes].each do |key, value| 
         
              
               @years.each do |key_year, value_year|
      
                 unless value[key_year.year-@year_min].nil?               
                    @years[key_year] = @years[key_year] + value[key_year.year-@year_min]
                    @years_totales[key_year] = @years_totales[key_year] + value[key_year.year-@year_min]
                 end 
               end

           end            
          end


         @meses_totales[num_mes]   = @years

          
    end 

   # calculo la suma del total de todos los años
   @years_totales[@year_max+1] = 0 
   @years_totales.each do |key, value|
        unless key == (@year_max+1) then  # Si la columna es la sumatoria, no la sumamos de nuevo
          @years_totales[@year_max+1] = @years_totales[@year_max+1] + value         
        end 
   end         

end

def index_expect_real_dividend_month
  @real_dividends_current_month= current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_month,Time.now.end_of_month).order(:operation_date, :company_id)
  @expected_dividends_current_month= current_user.expected_dividends.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_month,Time.now.end_of_month).order(:operation_date, :company_id)

end




def index_estimated_movements  

   #PopulateEstimatedMovementsJob.perform_now

   # Movimientos previstos del mes

   @ini_mes = (Time.now.year.to_s + "-" + params[:filter_month] + "-01").to_date

   
   @estimated_movements_current_month =current_user.estimated_movements.where('movement_date >= ? and movement_date <= ?',  @ini_mes, @ini_mes.end_of_month).group(:account_name).group_by_day(:movement_date, format: "%-d").sum(:amount)
 
   # @estimated_movements_current_month = current_user.estimated_movements.where('movement_date >= ? and movement_date <= ?', @ini_mes, @ini_mes.end_of_month).group_by_day(:movement_date, format: "%-d").sum(:amount)
   # # recorro el array y lo relleno con los días que faltan para que se muestren todos en el gráfico
   #  dia = 1
   #  while dia <= @ini_mes.end_of_month.day do
   
       
   #     if @estimated_movements_current_month[dia.to_s].nil? then
   #         @estimated_movements_current_month[dia.to_s] = 0
     
   #     end
   #     dia = dia + 1
   #  end


   # pendientes por cuenta bancaria
   # si es el mes actual tenemos que coger sólo a partir de la fecha actual (para que no salgan los vencidos)
   # sino, deben salir todos
   if Time.now.month == @ini_mes.month 
      fecha_pending = Time.now
   else
      fecha_pending = @ini_mes
   end 
   @pending_movements_current_month_by_account = current_user.estimated_movements.where('movement_date >= ? and movement_date <= ?', fecha_pending, @ini_mes.end_of_month).group(:account_id).sum(:amount)

   # todos los movimientos del mes
   @pending_movements_current_month_list = current_user.estimated_movements.where('movement_date >= ? and movement_date <= ?', @ini_mes, @ini_mes.end_of_month).order(:movement_date)

end

def index_sales_year
#  @sales_year= current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_SALE, Time.now.beginning_of_year,Time.now.end_of_year).order(:operation_date, :company_id)  
  @sales_year= current_user.operations.where('operationtype_id = ? ', Mycapital::OP_SALE).order(:operation_date, :company_id).order(:operation_date)  
end



end
