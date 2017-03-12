class AddAveragePriceRealToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :average_price_real, :float
    add_column :companies, :average_price_origin_currency_real, :float
  end
end
