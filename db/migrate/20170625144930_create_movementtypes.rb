class CreateMovementtypes < ActiveRecord::Migration
  def change
    create_table :movementtypes do |t|
      t.string :name
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
