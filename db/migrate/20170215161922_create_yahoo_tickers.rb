class CreateYahooTickers < ActiveRecord::Migration
  def change
    create_table :yahoo_tickers do |t|
      t.string :ticker
      t.string :name
      t.string :exchange
      t.string :name_country
      t.string :category

      t.timestamps null: false
    end
  end
end
