class AddRetrievedAutoToCompanyHistoricDividends < ActiveRecord::Migration
  def change
    add_column :company_historic_dividends, :retrieved_auto, :boolean, :default => false
  end
end
