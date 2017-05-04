class TargetsController < ApplicationController
  def index
  	 #SharePriceUpdateFromgooglefinanceJob.perform_now
  	 @greens = current_user.companies.verde
  	 @yellows = current_user.companies.amarillo
  	 @greys = current_user.companies.gris
  	 @reds = current_user.companies.rojo

  end
end
