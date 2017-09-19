class Settings
	def self.saluda
		"BME:ABE"
	end

	def self.google_prefixes
		# Recupera los prefijos de búsqueda en google y lo guarda en un array.
		# sólo ejecuta la select en stockexchanges la primera vez, qeu es cuando nle array está en blanco.
		if @google_prefix.nil?  
			@google_prefix = {}

			@stocks = Stockexchange.all

		    @stocks.each do |stockexchange| 
		    	if stockexchange.google_prefix.nil? then
		    		@google_prefix[stockexchange.id] = ""
		    	else	
		    		@google_prefix[stockexchange.id] = stockexchange.google_prefix

		    	end
		  
		     end
	    end 
	    @google_prefix
	end

	def self.stockexchange_symbol

		if @stockexchange_currency_symbols.nil?  
			@stockexchange_currency_symbols = {}


		    Stockexchange.all.each do |stockexchange| 
		    	if stockexchange.currency.symbol.nil? then
		    		@stockexchange_currency_symbols[stockexchange.id] = ""
		    	else	
		    		@stockexchange_currency_symbols[stockexchange.id] = stockexchange.currency.symbol  

		    	end
		  
		     end
	    end 
	    @stockexchange_currency_symbols


	end
end