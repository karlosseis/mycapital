class AddVariousToBalances < ActiveRecord::Migration
  def change
    add_column :balances, :details, :text
    add_column :balances, :total_sum, :float
    add_column :balances, :cash_sum, :float
    add_column :balances, :loan_sum, :float
    add_column :balances, :portfolio_sum, :float
  end
end
