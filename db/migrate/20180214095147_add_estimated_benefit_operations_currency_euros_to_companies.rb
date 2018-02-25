class AddEstimatedBenefitOperationsCurrencyEurosToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :estimated_benefit_operations_currency_euros, :float, :default => 0
  end
end
