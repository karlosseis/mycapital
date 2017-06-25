class CreatePlanifRecords < ActiveRecord::Migration
  def change
    create_table :planif_records do |t|
      t.string :name
      t.float :amount
      t.integer :day
      t.integer :start_month
      t.date :start_at
      t.date :end_at
      t.references :subcategory, index: true, foreign_key: true
      t.references :account, index: true, foreign_key: true
      t.references :periodicity, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
