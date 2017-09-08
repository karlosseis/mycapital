class AddTargetSellPriceToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :target_sell_price, :float, :default => 0
  end
end
