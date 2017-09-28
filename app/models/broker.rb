class Broker < ActiveRecord::Base
  belongs_to :user
  has_many :operations
  has_many :companies
  def to_s
    name
  end

end
