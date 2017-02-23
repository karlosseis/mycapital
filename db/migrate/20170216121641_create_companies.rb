class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :symbol
      t.references :stockexchange, index: true, foreign_key: true
      t.references :sector, index: true, foreign_key: true
      t.float :share_price
      t.string :search_symbol
      t.date :date_share_price
      t.float :dividend_sum
      t.float :puchased_sum
      t.float :sold_sum
      t.float :ampliated_sum
      t.float :quantity_puchased
      t.float :quantity_sold
      t.float :quantity_ampliated
      t.float :shares_sum
      t.float :invested_sum
      t.float :average_price
      t.float :share_price_global_currency
      t.float :estimated_value_global_currency
      t.float :estimated_benefit_global_currency
      t.float :perc_estimated_benefit_global_currency
      t.float :average_price_origin_currency
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
