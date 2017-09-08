module ApplicationHelper

	def format_date(date_value)
		unless date_value.nil?
			I18n.l(date_value)
		end		

	end

 def convert_to_eur(amount, currency_origin) 
    # share prices in currency purchases (ie, all the operations are bought in euros, 
    # the currency will be euros)
    unless currency_origin =="EUR"
   
      require 'money'
      require 'money/bank/google_currency'      
      bank = Money::Bank::GoogleCurrency.new
      #if currency_origin = 'p'
      #	currency_origin = 'GBP'      	
      #end
      
      begin ## ESTE BEGIN DEBERÍA IR AL PRINCIPIO, PARA CUANDO NO TENGO INTERNET
        amount = amount * bank.get_rate(currency_origin, Mycapital::CURRENCY_PURCHASE).to_f
        # la cotización de las acciones UK vienen en peniques y google currency  no tiene el tipo de cambio
        # por tanto, recuperamos la cotización en libras y dividimos por 100, que es lo mismo. 
     
      rescue  
        amount = 0
      end
      
    end
    
    unless amount.nil?
        amount.round(2)
    end
    
  end	
end
