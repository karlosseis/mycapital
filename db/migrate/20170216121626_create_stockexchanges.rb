class CreateStockexchanges < ActiveRecord::Migration
  def change
    create_table :stockexchanges do |t|
      t.string :name
      t.references :country, index: true, foreign_key: true
      t.references :currency, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
