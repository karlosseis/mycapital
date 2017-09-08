class AddMoreFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :shares_quantity, :float, :default => 0
    add_column :companies, :payout, :float, :default => 0
    add_column :companies, :dividend_payments_quantity, :integer, :default => 0
    add_column :companies, :historic_dividend_url, :string
  end
end
