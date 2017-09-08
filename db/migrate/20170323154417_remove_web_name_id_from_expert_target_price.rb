class RemoveWebNameIdFromExpertTargetPrice < ActiveRecord::Migration
  def change
    remove_column :expert_target_prices, :web_name_id, :integer
  end
end
