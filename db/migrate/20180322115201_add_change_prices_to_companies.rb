class AddChangePricesToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :share_price_change_perc, :float, :default => 0
    add_column :companies, :share_price_change, :float, :default => 0
  end
end
