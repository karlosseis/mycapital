class AddUserIdToExpertTargetPrices < ActiveRecord::Migration
  def change
    add_column :expert_target_prices, :user_id, :integer
  end
end
