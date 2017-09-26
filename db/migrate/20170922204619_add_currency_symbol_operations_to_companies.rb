class AddCurrencySymbolOperationsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :currency_symbol_operations, :string
  end
end
