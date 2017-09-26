class RemoveBenefitsGlobalFromCompany < ActiveRecord::Migration
  def change
    remove_column :companies, :estimated_value_global_currency, :float
    remove_column :companies, :estimated_benefit_global_currency, :float
    remove_column :companies, :perc_estimated_benefit_global_currency, :float
  end
end
