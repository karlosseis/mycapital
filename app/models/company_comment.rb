class CompanyComment < ActiveRecord::Base
  belongs_to :company
  belongs_to :user

  def to_s
    comment
  end  
end
