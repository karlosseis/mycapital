class TargetsController < ApplicationController
  def index
  	 @greens = current_user.companies.verde
  end
end
