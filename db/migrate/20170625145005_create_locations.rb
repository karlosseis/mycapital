class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :name_long
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
