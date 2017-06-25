class PopulateEstimatedMovementsJob < ActiveJob::Base

	# PopulateEstimatedMovementsJob.perform_now
  queue_as :default

  def perform(*args)
		EstimatedMovement.delete_all

		
    	 PlanifRecord.where('start_at >= ?', (Time.now).beginning_of_day).find_each do |plan|

			mes = plan.start_month

    	 	while mes <= 12 do		
    	 		
    	 		#plan.movement_date + 1.year
    	 		fecha_mov = Time.now.year.to_s + "-" + mes.to_s + "-" + plan.day.to_s

				EstimatedMovement.create(:name => plan.name,
										:amount => plan.amount,
										:movement_date => fecha_mov.to_date,
										:subcategory_id => plan.subcategory_id,										
										:account_id => plan.account_id,
										:month_number => mes.to_s,
										:user_id => plan.user_id)

				#:movementtype_id => plan.movementtype_id,
				mes = mes + plan.periodicity.num_months

			end

		end
  end
end
