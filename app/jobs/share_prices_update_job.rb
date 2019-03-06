class SharePricesUpdateJob < ActiveJob::Base
# SharePricesUpdateJob.perform_now
   queue_as :default

  def perform(*args)
    

		require 'bundler'
		Bundler.require

		# Authenticate a session with your Service Account
		session = GoogleDrive::Session.from_service_account_key("client_secret.json")

		# Get the spreadsheet by its title
		spreadsheet = session.spreadsheet_by_title("mycapital_empresas_no_usa")
		# Get the first worksheet
		worksheet = spreadsheet.worksheets.first
		# Print out the first 6 columns of each row

		Company.find_each do |q|
		#q = Company.find(131)
			begin
				# si es mercado americano lo pillamos de google
				if q.IEX_avaliable

	  		  		q.set_stock_price_IEX
	  		  		

	  		  	else
	  		  		# sino, lo pillamos de la hoja del drive
	  		  		worksheet.rows.each { |row| 

	  		  			share_price =  row[2]
	  		  			share_price_change_perc=  row[3]
	  		  			share_price_change =  row[4]   

	  		  			share_price.sub!(',','.')
						share_price_change_perc.sub!(',','.')
						share_price_change.sub!(',','.')

	  		  			if row[0] == q.google_symbol
							q.share_price =  share_price.to_f   
							q.share_price_change_perc =  share_price_change_perc.to_f
							q.share_price_change =  share_price_change.to_f     							  
							#q.set_update_summary
	
					         if Settings.stockexchange_currency_name[q.stockexchange_id] == 'GBP' then
					            q.share_price = share_price.to_f  / 100
					         end    
	
	  		  			end


  

	  		  		}	
	  		  		q.date_share_price = Time.now

	  		  	end
	  		  	q.share_price_global_currency = q.share_price * Settings.convert_currency(q.stockexchange_currency_name, Mycapital::CURRENCY_PURCHASE)
	  		  	
	  		  	q.save
			rescue => ex
			  logger.error ex.message
			end
  
		end
	
  end
end
