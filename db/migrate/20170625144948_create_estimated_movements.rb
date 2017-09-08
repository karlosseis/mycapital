class CreateEstimatedMovements < ActiveRecord::Migration
  def change
    create_table :estimated_movements do |t|
      t.string :name
      t.float :amount
      t.date :movement_date
      t.references :subcategory, index: true, foreign_key: true
      t.references :movementtype, index: true, foreign_key: true
      t.references :account, index: true, foreign_key: true
      t.integer :month_number
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
