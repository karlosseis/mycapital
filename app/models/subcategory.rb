class Subcategory < ActiveRecord::Base

  belongs_to :category
  belongs_to :user

  validates :name,
            presence: true
              
  has_many :planif_records, dependent: :destroy
  #has_many :records, dependent: :destroy
  #has_many :estimated_records, dependent: :destroy
  
  #accepts_nested_attributes_for :import_categories
  accepts_nested_attributes_for :planif_records
  #accepts_nested_attributes_for :records
  #accepts_nested_attributes_for :estimated_records
  def to_s
    name
  end
end
