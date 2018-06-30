class PopulateExpectedDividendsJob < ActiveJob::Base	
  queue_as :default

# PopulateExpectedDividendsJob.perform_now

  def perform(*args)
    	# buscamos todos los dividendos de hace un año apuntados en el historial de dividendos
    	# le sumamos un año a la fecha del cobro de dividendo para que salga el año actual
    	
		ExpectedDividend.delete_all

		tax_spain = Country.find(Mycapital::ID_PAIS).perc_tax
    	
    	CompanyHistoricDividend.where('payment_date >= ? and payment_date <= ?',  (Time.now - 1.year).beginning_of_year,(Time.now - 1.year).end_of_year)
.find_each do |hist|
			amount = 0

			# Tomamos el número de acciones que teníamos al record date  
			# (le sumamos un año porque en el recordset tenemos los dividendos hasta la fecha actual, es decir, el año pasado)
			shares_number = hist.company.get_shares_sum_at_date(hist.record_date + 1.year)
			
			unless hist.amount.nil?  or shares_number == 0

				amount = hist.amount 
				amont_minus_tax_origin = 0
				
				unless hist.company.country.perc_tax == 0	 or hist.company.stockexchange.country_id ==  Mycapital::ID_PAIS
					# si el país no es españa y tiene retención en origen, se la restamos. 
					amount = amount - (amount * hist.company.country.perc_tax) / 100
				end

				amont_minus_tax_origin = amount
				# le restamos la retencion en destino (españa)
				amount = amount - (amount * tax_spain) / 100 

				ExpectedDividend.create(:operationtype_id => Mycapital::OP_DIVIDEND,
														:company_id => hist.company_id,
														:operation_date => hist.payment_date + 1.year,
														:quantity => shares_number,
														:price_unit => amount,
														:amount => (amount * shares_number).round(2),
														:currency_id => hist.company.stockexchange.currency_id,
														:origin_price => 0,
														:origin_price_unit => 0,
														:origin_amount => 0,
														:user_id => hist.user_id)	


			end
	
		end
  end


#  def perform(*args)
#     	# buscamos todos los dividendos de hace un año 
#     	# recalculamos el total previsto a partir del precio por acción en el momento de cobrar el dividendo * número actual de acciones
#     	# deberíamos hacerlo también para el precio en moneda de origen, pero no tengo la información en ING
#     	# le sumamos un año a la fecha del cobro de dividendo para que salga el año actual
    	
# 		ExpectedDividend.delete_all
# #Operation.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, Time.now.beginning_of_day - 1.year,  Time.now.end_of_day)
# #.find_each do |oper|
		
#     	 Operation.where('operationtype_id = ? and operation_date >= ? and operation_date <= ?', Mycapital::OP_DIVIDEND, (Time.now - 1.year).beginning_of_year,(Time.now - 1.year).end_of_year)
# .find_each do |oper|
# 			ExpectedDividend.create(:operationtype_id => oper.operationtype_id,
# 									:company_id => oper.company_id,
# 									:operation_date => oper.operation_date + 1.year,
# 									:quantity => oper.company.shares_sum,
# 									:price_unit => oper.net_amount / oper.quantity,
# 									:amount => ((oper.net_amount / oper.quantity) * oper.company.shares_sum).round(2),
# 									:currency_id => oper.currency_id,
# 									:origin_price => (oper.net_amount / oper.quantity) * oper.company.shares_sum,
# 									:origin_price_unit => 0,
# 									:origin_amount => 0,
# 									:user_id => oper.user_id)
# 		end
#   end

end
