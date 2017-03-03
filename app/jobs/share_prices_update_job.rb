class SharePricesUpdateJob < ActiveJob::Base
# SharePricesUpdateJob.perform_now
   queue_as :default

  def perform(*args)
    	
		Company.find_each do |q|

			begin
  		  		q.set_stock_price
  		  		q.save
			rescue => ex
			  logger.error ex.message
			end
  
		end
	
  end
end
