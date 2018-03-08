class AddTaxRateAutoToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :tax_rate_auto, :float, :default => 0
  end
end
