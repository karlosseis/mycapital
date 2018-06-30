class AddCountryIdToCompanies < ActiveRecord::Migration
  def change
    add_reference :companies, :country, index: true, foreign_key: true
  end
end
