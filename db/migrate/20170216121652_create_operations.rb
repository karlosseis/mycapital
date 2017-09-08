class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.references :company, index: true, foreign_key: true
      t.references :operationtype, index: true, foreign_key: true
      t.float :amount
      t.text :comments
      t.float :commission
      t.references :currency, index: true, foreign_key: true
      t.float :destination_tax
      t.float :exchange_rate
      t.float :fee
      t.float :gross_amount
      t.float :net_amount
      t.date :operation_date
      t.float :origin_price
      t.float :price
      t.integer :quantity
      t.float :withholding_tax
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
