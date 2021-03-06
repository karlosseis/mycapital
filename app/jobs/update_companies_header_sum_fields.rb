class UpdateCompaniesHeaderSumFields < ActiveJob::Base
# UpdateCompaniesHeaderSumFields.perform_now
   queue_as :default

  def perform(*args)
    	
		Company.find_each do |q|

			begin
				q.set_update_summary
				q.retrieve_IEX_dividends_batch
  		  		q.set_next_official_dividend_values
  		  		q.set_last_result_values
  		  		q.set_img_logo
  		  		q.save
			rescue => ex
			  logger.error ex.message
			end
  
		end
	
  end
end
