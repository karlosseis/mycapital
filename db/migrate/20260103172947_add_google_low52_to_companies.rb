class AddGoogleLow52ToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :google_low52, :decimal, precision: 15, scale: 6, default: 0, null: false
  end
end