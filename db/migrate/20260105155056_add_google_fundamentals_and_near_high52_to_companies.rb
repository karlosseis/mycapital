class AddGoogleFundamentalsAndNearHigh52ToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :google_market_cap, :decimal, precision: 20, scale: 2, default: 0, null: false
    add_column :companies, :google_per,        :decimal, precision: 15, scale: 6, default: 0, null: false
    add_column :companies, :google_bpa,        :decimal, precision: 15, scale: 6, default: 0, null: false
    add_column :companies, :google_beta,       :decimal, precision: 15, scale: 6, default: 0, null: false

    add_column :companies, :near_high52, :boolean, default: false, null: false
    add_index  :companies, :near_high52
  end
end
