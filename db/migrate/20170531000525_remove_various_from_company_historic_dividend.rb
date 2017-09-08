class RemoveVariousFromCompanyHistoricDividend < ActiveRecord::Migration
  def change
    remove_column :company_historic_dividends, :payment_Date, :date
    remove_column :company_historic_dividends, :amount, :string
    remove_column :company_historic_dividends, :float, :date
  end
end
