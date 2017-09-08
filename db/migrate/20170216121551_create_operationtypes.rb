class CreateOperationtypes < ActiveRecord::Migration
  def change
    create_table :operationtypes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
