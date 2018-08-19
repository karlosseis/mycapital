class AddEarningsSumToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :earnings_sum, :float, :default => 0
    add_column :operations, :earnings_sum_euros, :float, :default => 0
  end
end
