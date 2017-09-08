# == Schema Information
#
# Table name: sectors
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sector < ActiveRecord::Base
  validates :name,
            presence: true
  has_many :companies, dependent: :destroy    	
  def to_s
    name
  end
end
