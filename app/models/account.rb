class Account < ActiveRecord::Base
  belongs_to :bank
  belongs_to :user
  validates :name,
            presence: true

  has_many :balance_details 
  has_many :planif_records 
  has_many :movements 
  #..
  enum account_type_id: {efectivo: 1, cartera: 2, prestamo: 3, otros: 0}
  def to_s
    name
  end

end
