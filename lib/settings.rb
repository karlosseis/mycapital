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
end