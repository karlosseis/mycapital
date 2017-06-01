class CompanyHistoricDividend < ActiveRecord::Base
  belongs_to :company
  belongs_to :user

  after_save :update_company
  after_destroy :update_company 

  def update_company  	
  	self.company.set_next_official_dividend_values() 
  	self.company.save  		
  
  end
    
end
