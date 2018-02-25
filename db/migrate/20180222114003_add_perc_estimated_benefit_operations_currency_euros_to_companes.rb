class AddPercEstimatedBenefitOperationsCurrencyEurosToCompanes < ActiveRecord::Migration
  def change
    add_column :companies, :perc_estimated_benefit_operations_currency_euros, :float, :default => 0
  end
end
