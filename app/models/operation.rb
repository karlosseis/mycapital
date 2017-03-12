class Operation < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :company
  belongs_to :operationtype
  belongs_to :currency
  belongs_to :user
  
  before_validation :update_origin_price
  after_save :update_company
  after_destroy :update_company
 
  # after_initialize  :set_operation_date
  
  # def set_operation_date
  #   if self.new_record?
  #     self.operation_date = Time.now
  #   end
  # end
 
  validates :operation_date, presence: true
  validates :quantity,  presence: true, :numericality => { :greater_than => 0}
  validates :exchange_rate, :numericality => { :greater_than => 0}, if: :foreign_currency_field_required? 

  validates :price, :numericality => { :greater_than => 0}, if: :is_purchase?  
  validates :amount, :numericality => { :greater_than => 0}, if: :is_purchase?
  #validates :commission, :numericality => { :greater_than => 0}, if: :is_purchase? 
  validates :fee, :numericality => { :greater_than => 0}, if: :is_purchase? 
  validates :origin_price, :numericality => { :greater_than => 0}, if: :is_purchase? 

  

  validates :price, :numericality => { :greater_than => 0}, if: :is_sale?  
  validates :amount, :numericality => { :greater_than => 0}, if: :is_sale?
  validates :commission, :numericality => { :greater_than => 0}, if: :is_sale? 
  validates :fee, :numericality => { :greater_than => 0}, if: :is_sale? 
  validates :origin_price, :numericality => { :greater_than => 0}, if: :is_sale? 
 


  #validates :price, :numericality => { :greater_than => 0}, if: :is_sale? 
  #validates :amount, :numericality => { :greater_than => 0}, if: :is_ampliation?
  #validates :commission, :numericality => { :greater_than => 0}, if: :is_ampliation? 
  #validates :fee, :numericality => { :greater_than => 0}, if: :is_ampliation? 
  #validates :origin_price, :numericality => { :greater_than => -1}, if: :is_ampliation? 
 


  validates :net_amount, :numericality => { :greater_than => 0}, if: :is_dividend?
  validates :gross_amount, :numericality => { :greater_than => 0}, if: :is_dividend?
  #validates :withholding_tax, :numericality => { :greater_than => 0}, if: :is_dividend?
  validates :destination_tax, :numericality => { :greater_than => 0}, if: :is_dividend?



  def origin_price_formatted
    number_to_currency(self.origin_price, unit:self.currency.symbol, seperator: ",", delimiter: ".")
  end
  
  def foreign_currency_field_required?
     self.currency.to_s != Mycapital::CURRENCY_PURCHASE.to_s && !self.is_dividend?
  end

  def is_purchase?
    self.operationtype_id == Mycapital::OP_PURCHASE
  end

  def is_dividend?
    self.operationtype_id == Mycapital::OP_DIVIDEND
  end

  def is_sale?
    self.operationtype_id == Mycapital::OP_SALE
  end

  def is_ampliation?
    self.operationtype_id == Mycapital::OP_AMPLIATION
  end


  def update_company  	
  	self.company.set_update_summary()  #:operationtype_id
  	self.company.save  		
  
  end

  def update_origin_price
     # si la moneda de la empresa es la moneda del sistema, el precio en origen será el mismo que Price. 
     # Es decir, si la empresa es española, el precio origen será el mismo en el que compramos (euros)

     # grabo la moneda de la empresa porque aunque la grabo en el new, si no muestro el campo en pantalla no me hace caso.
    self.currency_id = self.company.stockexchange.currency_id
     if (self.currency.to_s == Mycapital::CURRENCY_PURCHASE.to_s)
        self.origin_price = self.price
        self.exchange_rate = 1
     end
  end

end
