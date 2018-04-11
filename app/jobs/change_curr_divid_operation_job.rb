class ChangeCurrDividOperationJob < ActiveJob::Base
  queue_as :default

# 09.04.2018 - fue de un solo uso

# ChangeCurrDividOperationJob.perform_now
  def perform(*args)
    # Do something later

      Operation.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => 2).find_each do |q|

          begin
                q.currency_id = 1
                q.save
          rescue => ex
            logger.error ex.message
          end
      
        end

      Operation.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => 101).find_each do |q|

          begin
                q.currency_id = 1
                q.save
          rescue => ex
            logger.error ex.message
          end
      
        end


  end

end
