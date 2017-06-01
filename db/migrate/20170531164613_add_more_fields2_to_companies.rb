class AddMoreFields2ToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :next_exdividend_date, :date
    add_column :companies, :next_dividend_date, :date
    add_column :companies, :next_dividend_amount, :float
  end
end
