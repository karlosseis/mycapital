class AddBrokerToCompanies < ActiveRecord::Migration
  def change
    add_reference :companies, :broker, index: true, foreign_key: true
  end
end
