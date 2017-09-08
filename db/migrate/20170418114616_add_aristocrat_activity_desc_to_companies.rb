class AddAristocratActivityDescToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :dividend_aristocrat, :boolean
    add_column :companies, :activity_description, :text
  end
end
