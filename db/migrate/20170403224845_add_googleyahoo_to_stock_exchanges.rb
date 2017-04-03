class AddGoogleyahooToStockExchanges < ActiveRecord::Migration
  def change
    add_column :stockexchanges, :google_prefix, :string
    add_column :stockexchanges, :yahoo_suffix, :string
  end
end
