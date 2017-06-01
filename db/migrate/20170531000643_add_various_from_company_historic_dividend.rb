class AddVariousFromCompanyHistoricDividend < ActiveRecord::Migration
  def change
    add_column :company_historic_dividends, :payment_date, :date
    add_column :company_historic_dividends, :amount, :float
  end
end
