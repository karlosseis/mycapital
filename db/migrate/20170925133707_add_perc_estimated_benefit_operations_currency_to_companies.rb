class AddPercEstimatedBenefitOperationsCurrencyToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :perc_estimated_benefit_operations_currency, :float, :default => 0
  end
end
