class PopulateExpectedDividendsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    	# buscamos todos los dividendos de hace un año 
    	# recalculamos el total previsto a partir del precio por acción en el momento de cobrar el dividendo * número actual de acciones
    	# deberíamos hacerlo también para el precio en moneda de origen, pero no tengo la información en ING
    	# le sumamos un año a la fecha del cobro de dividendo para que salga el año actual
    	
		ExpectedDividend.delete_all
#Operation.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_day - 1.year,  Time.now.end_of_day)
#.find_each do |oper|
		
    	 Operation.where('operationtype_id = ? and year(operation_date) = ?', Mycapital::OP_DIVIDEND, Time.now.year - 1)
.find_each do |oper|
			ExpectedDividend.create(:operationtype_id => oper.operationtype_id,
									:company_id => oper.company_id,
									:operation_date => oper.operation_date + 1.year,
									:quantity => oper.company.shares_sum,
									:price_unit => oper.net_amount / oper.quantity,
									:amount => ((oper.net_amount / oper.quantity) * oper.company.shares_sum).round(2),
									:currency_id => oper.currency_id,
									:origin_price => (oper.net_amount / oper.quantity) * oper.company.shares_sum,
									:origin_price_unit => 0,
									:origin_amount => 0,
									:user_id => oper.user_id)
		end
  end
end
