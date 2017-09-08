class AddOpenclosemarketToStockExchanges < ActiveRecord::Migration
  def change
    add_column :stockexchanges, :open_time, :time
    add_column :stockexchanges, :close_time, :time
  end
end
