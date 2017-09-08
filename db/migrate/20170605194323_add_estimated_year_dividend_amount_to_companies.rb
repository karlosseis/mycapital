class AddEstimatedYearDividendAmountToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :estimated_year_dividend_amount, :float
  end
end
