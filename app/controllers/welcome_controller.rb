class WelcomeController < ApplicationController
  def index
  	@mi_portfolio = MyPortfolioSummary.new(Company)
  end
end
