class AddAccountNameToEstimatedMovements < ActiveRecord::Migration
  def change
    add_column :estimated_movements, :account_name, :string
  end
end
