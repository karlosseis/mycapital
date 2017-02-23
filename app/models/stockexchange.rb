# == Schema Information
#
# Table name: stockexchanges
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  country_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  currency_id :integer
#

class Stockexchange < ActiveRecord::Base
 belongs_to :country
 belongs_to :currency
  validates :name,
            presence: true

  has_many :companies, dependent: :destroy            
  def to_s
    name
  end
end
