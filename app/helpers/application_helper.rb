module ApplicationHelper

	def format_date(date_value)
		unless date_value.nil?
			I18n.l(date_value)
		end		

	end

  def format_currency(value, symbol)
    number_to_currency(value, unit:symbol, seperator: ",", delimiter: ".")
  end

  
   def convert_to_eur(amount, currency_origin)      


      amount = amount * Settings.convert_currency(currency_origin, Mycapital::CURRENCY_PURCHASE)
      
      unless amount.nil?
          amount.round(2)
      end
      
    end	
end
