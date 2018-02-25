class AddPercTaxToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :perc_tax, :float, :default => 0
  end
end
