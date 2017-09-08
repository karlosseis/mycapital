class Movement < ActiveRecord::Base
  belongs_to :subcategory
  belongs_to :movementtype
  belongs_to :account
  belongs_to :location
  belongs_to :user
end
