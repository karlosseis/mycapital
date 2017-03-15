class BalanceDetail < ActiveRecord::Base
  belongs_to :balance
  belongs_to :account
  belongs_to :user

  after_save :update_balance
  after_destroy :update_balance
  def to_s  

    unless name.nil? 
  		name
  	else
  		""
	  end

  end
  def update_balance    
    self.balance.set_totals()  
    self.balance.save     
  
  end  

end
