class AddReferenceWebId2ToExpertTargetPrices < ActiveRecord::Migration
  def change
    add_column :expert_target_prices, :reference_web_id, :integer
  end
end
