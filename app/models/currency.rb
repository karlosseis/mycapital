# == Schema Information
#
# Table name: currencies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Currency < ActiveRecord::Base
  has_many :stockexchanges, dependent: :destroy
  def to_s
    name
  end
end
