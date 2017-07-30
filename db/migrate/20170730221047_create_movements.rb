class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :name
      t.float :amount
      t.date :movement_date
      t.references :subcategory, index: true, foreign_key: true
      t.references :movementtype, index: true, foreign_key: true
      t.references :account, index: true, foreign_key: true
      t.references :location, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
