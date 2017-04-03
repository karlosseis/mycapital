class RemoveReferenceWebFromExpertTargetPrice < ActiveRecord::Migration
  def change
    remove_column :expert_target_prices, :reference_web, :integer
  end
end
