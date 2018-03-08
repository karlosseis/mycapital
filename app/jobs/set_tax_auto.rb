class SetTaxAuto < ActiveJob::Base
  queue_as :default
  # establece la tasa de cambio del día para todas las operaciones
# SetTaxAuto.perform_now
  def perform(*args)
    # Do something later

      Operation.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => 2).find_each do |q|

          begin
                q.update_tax_rate_auto
                q.save
          rescue => ex
            logger.error ex.message
          end
      
        end

      Operation.where(:operationtype_id => Mycapital::OP_DIVIDEND, :currency_id => 101).find_each do |q|

          begin
                q.update_tax_rate_auto
                q.save
          rescue => ex
            logger.error ex.message
          end
      
        end


  end

end
