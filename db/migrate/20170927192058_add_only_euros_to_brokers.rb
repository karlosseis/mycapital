class AddOnlyEurosToBrokers < ActiveRecord::Migration
  def change
    add_column :brokers, :only_euros, :boolean, :default => true
  end
end
