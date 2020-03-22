class AddImageRatesCompanies < ActiveRecord::Migration[6.0]
  def change
  	add_column :companies, :logo_url, :string, :default => ''
  end
end
