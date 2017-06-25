class Periodicity < ActiveRecord::Base
	belongs_to :user

  validates :name,
            presence: true
            
  has_many :planif_records, dependent: :destroy
 
  
  accepts_nested_attributes_for :planif_records



  def to_s
    name
  end
end
