class MyPortfolioSummary 
   #  <%=  k = MyPortfolioSummary.new(@companies)  %>
 #<p> Saluda <%= k.kapullo %> </p>
 # # método inicializar clase
  def initialize(comp)
    # atributos   
 #    @total = 0
  # companies.each do |q|
 #        #@total =  @total + q.share_price
 #        @total =  @total + total_puchased_sum(q)
  # end

  
  @priv_global_value = comp.sum(:estimated_value_global_currency) 
    @priv_global_benefit = comp.sum(:estimated_benefit_global_currency) 
    @priv_global_invested = comp.sum(:invested_sum) 
  end  

  def hola
    puts 'Hola'
  end

  def global_value
    @priv_global_value.round(2)
  end

  def global_benefit
    @priv_global_benefit.round(2)
  end

  def global_invested
    @priv_global_invested.round(2)
  end   
  def global_perc_benefit
    @priv_total = 0
      unless @priv_global_invested.to_f == 0 then
          @priv_total = @priv_global_benefit.to_f * 100 / @priv_global_invested.to_f
      end
      @priv_total.round(2)
  end 

  def last_purchases(number)
    Operation.where(operationtype_id: Mycapital::OP_PURCHASE).order(operation_date: :desc).limit(number)    

  end

  def next_dividends(number)
    ExpectedDividend.where('operationtype_id = ? and operation_date >= ?', Mycapital::OP_DIVIDEND, Time.now).order(operation_date: :asc).limit(number)    
  end 

  def dividends_current_year  
    Operation.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_year,Time.now.end_of_year).sum(:net_amount)
  end

  def dividends_current_month 
    Operation.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_month,Time.now.end_of_month).sum(:net_amount)
  end

  def expected_dividends_current_year 
    ExpectedDividend.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_year,Time.now.end_of_year).sum(:amount)
  end

  def expected_dividends_current_month  
    ExpectedDividend.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_month,Time.now.end_of_month).sum(:amount)
  end

end