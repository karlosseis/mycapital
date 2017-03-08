class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index

	PopulateExpectedDividendsJob.perform_now(us: current_user)
	
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
end
