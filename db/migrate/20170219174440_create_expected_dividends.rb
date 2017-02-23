class CreateExpectedDividends < ActiveRecord::Migration
  def change
    create_table :expected_dividends do |t|
      t.references :company, index: true, foreign_key: true
      t.references :operationtype, index: true, foreign_key: true
      t.date :operation_date
      t.integer :quantity
      t.float :price_unit
      t.float :amount
      t.references :currency, index: true, foreign_key: true
      t.float :origin_price
      t.float :origin_price_unit
      t.float :origin_amount
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
