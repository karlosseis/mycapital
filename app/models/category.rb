class Category < ActiveRecord::Base
  has_many :subcategories, dependent: :destroy
  validates :name,
            presence: true
   belongs_to :user
  accepts_nested_attributes_for :subcategories
  def to_s
    name
  end
end
