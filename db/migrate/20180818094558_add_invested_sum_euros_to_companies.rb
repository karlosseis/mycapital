class AddInvestedSumEurosToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :invested_sum_euros, :float, :default => 0
    add_column :companies, :earnings_sum, :float, :default => 0
    add_column :companies, :earnings_sum_euros, :float, :default => 0
  end
end
