class Broker < ActiveRecord::Base
  belongs_to :user
  has_many :operations
  def to_s
    name
  end

end
