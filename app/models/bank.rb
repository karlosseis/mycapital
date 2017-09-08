class Bank < ActiveRecord::Base
  belongs_to :user
  has_many :accounts, dependent: :destroy
  validates :name,
            presence: true
  accepts_nested_attributes_for :accounts, reject_if: proc { |attributes| attributes['name'].blank? },
  						allow_destroy: true

  def to_s
    name
  end
  
end
