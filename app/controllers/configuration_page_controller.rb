class ConfigurationPageController < ApplicationController
  def index
  	@grouped_options = Category.all.map {|category| [category.name,category.subcategories.map {|subcategory| [subcategory.name,subcategory.id]}]}
  end
end
