class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index

    PopulateExpectedDividendsJob.perform_now()
  
    @global_value = current_user.companies.sum(:estimated_value_global_currency).round(2)
    @global_benefit = current_user.companies.sum(:estimated_benefit_global_currency).round(2) 
    @global_invested = current_user.companies.sum(:invested_sum).round(2)



    @global_perc_benefit = 0
    unless @global_invested.to_f == 0 then
      @global_perc_benefit = @global_benefit.to_f * 100 / @global_invested.to_f
    end
    @global_perc_benefit.round(2)
  

  
    @last_purchases = current_user.operations.where(operationtype_id: Mycapital::OP_PURCHASE).order(operation_date: :desc).limit(3)    
    @next_dividends= current_user.expected_dividends.where('operationtype_id = ? and operation_date >= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_day).order(operation_date: :asc).limit(3)    
    @purchases_current_year= current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_PURCHASE, Time.now.beginning_of_year,Time.now.end_of_year).sum(:amount)
    @dividends_current_year= current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_year,Time.now.end_of_year).sum(:net_amount)
    @dividends_current_month= current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_month,Time.now.end_of_month).sum(:net_amount)
    @expected_dividends_current_year= current_user.expected_dividends.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_year,Time.now.end_of_year).sum(:amount)

    @expected_dividends_group_month = current_user.expected_dividends.where(:operationtype_id => Mycapital::OP_DIVIDEND).group_by_month(:operation_date).sum(:amount)
    @real_dividends_group_month = current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, (Time.now).beginning_of_year,(Time.now).end_of_year).group_by_month(:operation_date).sum(:net_amount)
    @purchases_group_year = current_user.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).group_by_year(:operation_date, format: "%Y").sum(:amount)

    @real_dividends_group_year=  current_user.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND).group_by_year(:operation_date, format: "%Y").sum(:net_amount)

   




  end

  

  def index_historic_dividend

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
          @meses[key.month] = {comp[op.company_id] => years_company} 
        else 
          empresas_mes =  @meses[key.month]      
          if empresas_mes[comp[op.company_id]].nil? then 
            # Primer registro de la empresa en el mes, lo añadimos 
            years_company[year_array] = op.net_amount 
            @meses[key.month].merge!(comp[op.company_id] => years_company) 
          else 
            # la empresa tiene registro en el mes pero quizá no en el año. Lo validamos. 
            years_company = empresas_mes[comp[op.company_id]] 
            if years_company[year_array].nil? then 
              years_company[year_array] = op.net_amount 
            else 
              years_company[year_array] = years_company[year_array] + op.net_amount 
            end 
            @meses[key.month].merge!(comp[op.company_id] => years_company) 
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
  @real_dividends_current_month= current_user.operations.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_month,Time.now.end_of_month)
  @expected_dividends_current_month= current_user.expected_dividends.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_month,Time.now.end_of_month)

end

end
