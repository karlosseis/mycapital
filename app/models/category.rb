# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  has_many :subcategories, dependent: :destroy
  validates :name,
            presence: true
  accepts_nested_attributes_for :subcategories
  def to_s
    name
  end
end
