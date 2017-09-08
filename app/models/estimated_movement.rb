class EstimatedMovement < ActiveRecord::Base
  belongs_to :subcategory
  belongs_to :movementtype
  belongs_to :account
  belongs_to :user

  def to_s
    name
  end  
end
