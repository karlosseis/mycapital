class CreateExchangeRates < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
      t.date :date_exchange
      t.string :pair
      t.float :rate

      t.timestamps null: false
    end
  end
end
