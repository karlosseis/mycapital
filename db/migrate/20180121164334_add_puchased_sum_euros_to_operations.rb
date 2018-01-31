class AddPuchasedSumEurosToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :puchased_sum_euros, :float, :default => 0
  end
end
