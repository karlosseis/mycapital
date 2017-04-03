class AddVariousToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :target_price_1, :float, :default => 0
    add_column :companies, :target_price_2, :float, :default => 0
    add_column :companies, :traffic_light_id, :integer, :default => 0
    add_column :companies, :investors_url, :string
  end
end
