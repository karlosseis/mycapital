class Settings
	def self.saluda
		"BME:ABE"
	end

	def self.load_settings
		if @google_prefix.nil?  or @stockexchange_currency_symbols.nil?  or @yahoo_suffix.nil? or @stockexchange_currency_names.nil?
			@google_prefix = {}
			@yahoo_suffix = {}
			@stockexchange_currency_symbols = {}
			@stockexchange_currency_names = {}
			@stockexchange_currency_ids = {} ## guardo en la clave el símbolo y en el valor el id de la moneda
			@stocks = Stockexchange.all

		    @stocks.each do |stockexchange| 

		    	@stockexchange_currency_ids[stockexchange.currency.symbol]  = stockexchange.currency.id

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

		self.load_rates



	end

	def self.load_rates
		if @rates.nil?


			if ExchangeRate.all.where('date_exchange = ?',  Time.now.beginning_of_day).count==0
				# si lo pongo cada hora (beginning_of_hour) se disparan las llamadas y el límite son 1000 al mes
				fx = OpenExchangeRates::Rates.new
				@usd2eur = fx.convert(1, :from => "USD", :to => "EUR")
				@gbp2eur = fx.convert(1, :from => "GBP", :to => "EUR")
				@eur2usd = fx.convert(1, :from => "EUR", :to => "USD")
				@eur2gbp = fx.convert(1, :from => "EUR", :to => "GBP")
				@eur2gbp = fx.convert(1, :from => "EUR", :to => "AUD")
				@eur2gbp = fx.convert(1, :from => "AUD", :to => "EUR")

				a = []
				a << ExchangeRate.new(date_exchange: Time.now.beginning_of_day, pair: "USDEUR", rate: @usd2eur)
				a << ExchangeRate.new(date_exchange: Time.now.beginning_of_day, pair: "GBPEUR", rate: @gbp2eur)
				a << ExchangeRate.new(date_exchange: Time.now.beginning_of_day, pair: "AUDEUR", rate: @gbp2eur)
				a << ExchangeRate.new(date_exchange: Time.now.beginning_of_day, pair: "EURUSD", rate: @eur2usd)
				a << ExchangeRate.new(date_exchange: Time.now.beginning_of_day, pair: "EURGBP", rate: @eur2gbp)
				a << ExchangeRate.new(date_exchange: Time.now.beginning_of_day, pair: "EURAUD", rate: @eur2gbp)

				a.each(&:save)

			end

			@rates = {}
			ex = ExchangeRate.all.where('date_exchange = ?',  Time.now.beginning_of_day)

			ex.each do |x| 
				@rates[x.pair] = x.rate

			end

			
		end
	end

	def self.convert_currency (orig, dest)

		if orig == dest
			1		
		else
			self.load_rates
			pair = orig + dest
			@rates[pair]
			
		end

	end

	def self.stockexchange_currency_id
		self.load_settings
		@stockexchange_currency_ids
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