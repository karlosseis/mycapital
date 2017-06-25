class PlanifRecord < ActiveRecord::Base
  belongs_to :subcategory
  belongs_to :account
  belongs_to :periodicity
  belongs_to :user

  def to_s
    name
  end

  def category
  	subcat = Subcategory.find_by id: subcategory_id    
    Category.find_by id: subcat.category_id
  end

  def category_id
  	subcat = Subcategory.find_by id: subcategory_id    
    subcat.category_id
  end
end
