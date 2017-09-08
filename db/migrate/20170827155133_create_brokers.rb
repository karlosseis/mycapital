class CreateBrokers < ActiveRecord::Migration
  def change
    create_table :brokers do |t|
      t.string :name
      t.integer :buy_frequency
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
