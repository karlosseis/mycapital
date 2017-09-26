class AddMoreEstimatedValuesToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :estimated_value_operations_currency, :float
    add_column :companies, :estimated_benefit_operations_currency, :float
  end
end
