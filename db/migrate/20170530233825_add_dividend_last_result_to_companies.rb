class AddDividendLastResultToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :dividend_last_result, :float
  end
end
