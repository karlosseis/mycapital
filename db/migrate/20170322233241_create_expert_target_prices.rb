class CreateExpertTargetPrices < ActiveRecord::Migration
  def change
    create_table :expert_target_prices do |t|
      t.date :date_target_price
      t.float :target_price_1
      t.float :target_price_2
      t.integer :web_name_id
      t.string :url
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
