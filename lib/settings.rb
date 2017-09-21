class Settings
	def self.saluda
		"BME:ABE"
	end

	def self.load_settings
		if @google_prefix.nil?  or @stockexchange_currency_symbols.nil?  or @yahoo_suffix.nil? or @stockexchange_currency_name.nil?
			@google_prefix = {}
			@yahoo_suffix = {}
			@stockexchange_currency_symbols = {}
			@stockexchange_currency_names = {}
			@stocks = Stockexchange.all

		    @stocks.each do |stockexchange| 
		    	if stockexchange.google_prefix.nil? then
		    		@google_prefix[stockexchange.id] = ""
		    	else	
		    		@google_prefix[stockexchange.id] = stockexchange.google_prefix
		    	end

		    	if stockexchange.yahoo_suffix.nil? then
		    		@yahoo_suffix[stockexchange.id] = ""
		    	else	
		    		@yahoo_suffix[stockexchange.id] = stockexchange.yahoo_suffix
		    	end	

   				if stockexchange.currency.symbol.nil? then
		    		@stockexchange_currency_symbols[stockexchange.id] = ""
		    	else	
		    		@stockexchange_currency_symbols[stockexchange.id] = stockexchange.currency.symbol  

		    	end

   				if stockexchange.currency.name.nil? then
		    		@stockexchange_currency_names[stockexchange.id] = ""
		    	else	
		    		@stockexchange_currency_names[stockexchange.id] = stockexchange.currency.name  

		    	end

		     end

		end


	end



	def self.google_prefixes
		self.load_settings
		@google_prefix
	end

	def self.yahoo_suffixes
		self.load_settings
		@yahoo_suffix
		
	end

	def self.stockexchange_currency_symbol
		self.load_settings
		@stockexchange_currency_symbols
	end

	def self.stockexchange_currency_name
		self.load_settings
		@stockexchange_currency_names	
	end


	# def self.google_prefixes
	# 	# Recupera los prefijos de búsqueda en google y lo guarda en un array.
	# 	# sólo ejecuta la select en stockexchanges la primera vez, qeu es cuando nle array está en blanco.
	# 	if @google_prefix.nil?  
	# 		@google_prefix = {}

	# 		@stocks = Stockexchange.all

	# 	    @stocks.each do |stockexchange| 
	# 	    	if stockexchange.google_prefix.nil? then
	# 	    		@google_prefix[stockexchange.id] = ""
	# 	    	else	
	# 	    		@google_prefix[stockexchange.id] = stockexchange.google_prefix

	# 	    	end
		  
	# 	     end
	#     end 
	#     @google_prefix
	# end

	# def self.stockexchange_symbol

	# 	if @stockexchange_currency_symbols.nil?  
	# 		@stockexchange_currency_symbols = {}


	# 	    Stockexchange.all.each do |stockexchange| 
	# 	    	if stockexchange.currency.symbol.nil? then
	# 	    		@stockexchange_currency_symbols[stockexchange.id] = ""
	# 	    	else	
	# 	    		@stockexchange_currency_symbols[stockexchange.id] = stockexchange.currency.symbol  

	# 	    	end
		  
	# 	     end
	#     end 
	#     @stockexchange_currency_symbols


	# end
end