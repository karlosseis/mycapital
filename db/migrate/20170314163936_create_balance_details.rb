class CreateBalanceDetails < ActiveRecord::Migration
  def change
    create_table :balance_details do |t|
      t.string :name
      t.float :amount
      t.date :balance_date
      t.references :balance, index: true, foreign_key: true
      t.references :account, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
