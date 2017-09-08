# == Schema Information
#
# Table name: operationtypes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Operationtype < ActiveRecord::Base
  
  validates :name,
            presence: true
            
  has_many :operations, dependent: :destroy
 

  def to_s
    name
  end
end
