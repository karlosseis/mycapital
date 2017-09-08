# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Country < ActiveRecord::Base
  validates :name,
            presence: true
            
  has_many :stockexchanges, dependent: :destroy
 
 
  def to_s
    name
  end	
end
