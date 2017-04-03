class ReferenceWeb < ActiveRecord::Base
  belongs_to :user
  has_many :expert_target_price, dependent: :destroy
  validates :name,
            presence: true

  def to_s
    name
  end


end
