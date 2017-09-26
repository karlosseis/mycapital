class AddCurrencyOperationToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :currency_operation_id, :integer, foreign_key: true, :default => 1
  end
end
