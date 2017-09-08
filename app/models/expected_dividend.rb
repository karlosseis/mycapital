class ExpectedDividend < ActiveRecord::Base
  belongs_to :company
  belongs_to :operationtype
  belongs_to :currency
  belongs_to :user
end
