class AddReferenceWebIdToExpertTargetPrices < ActiveRecord::Migration
  def change
    add_column :expert_target_prices, :reference_web, :integer
  end
end
