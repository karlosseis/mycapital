class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.string :name
      t.date :balance_date
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
