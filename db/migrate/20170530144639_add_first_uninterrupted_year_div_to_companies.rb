class AddFirstUninterruptedYearDivToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :first_uninterrupted_year_div, :integer
  end
end
