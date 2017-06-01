class CreateCompanyHistoricDividends < ActiveRecord::Migration
  def change
    create_table :company_historic_dividends do |t|
      t.date :exdividend_date
      t.date :record_date
      t.date :announce_date
      t.date :payment_Date
      t.string :amount
      t.date :float
      t.integer :dividend_type, :default => 0
      t.references :company, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
