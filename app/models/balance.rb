class Balance < ActiveRecord::Base
  belongs_to :user
  has_many :balance_details, dependent: :destroy
  validates :name,
            presence: true
  accepts_nested_attributes_for :balance_details,reject_if: proc { |attributes| attributes['amount'].blank? }
  def to_s
    name
  end



  def set_totals
   self.total_sum = 0
   self.cash_sum  = 0
   self.loan_sum = 0
   self.portfolio_sum  = 0
   
   self.balance_details.each do |det|    
     self.total_sum = self.total_sum + det.amount   
        
     if det.account.efectivo? then
        self.cash_sum = self.cash_sum + det.amount   
     end
     if det.account.prestamo? then
        self.loan_sum = self.loan_sum + det.amount   
     end
     if det.account.cartera? then
        self.portfolio_sum = self.portfolio_sum + det.amount   
     end   
   end 

 
  end


 
end
