class AddPuchasedSumEurosToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :puchased_sum_euros, :float, :default => 0
  end
end
