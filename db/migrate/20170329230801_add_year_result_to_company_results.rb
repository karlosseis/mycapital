class AddYearResultToCompanyResults < ActiveRecord::Migration
  def change
    add_column :company_results, :year_result, :date
  end
end
