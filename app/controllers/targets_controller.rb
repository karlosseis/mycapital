class TargetsController < ApplicationController
  def index
  	 SharePriceUpdateFromgooglefinanceJob.perform_now
  	 @greens = current_user.companies.verde
  end
end
