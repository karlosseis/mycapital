class CreatePeriodicities < ActiveRecord::Migration
  def change
    create_table :periodicities do |t|
      t.string :name
      t.integer :num_months
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
