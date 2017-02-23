class ChangeDefaultValuesFromCompany < ActiveRecord::Migration
  def change

change_column_default(:companies, :share_price, 0)
change_column_default(:companies, :dividend_sum, 0)
change_column_default(:companies, :puchased_sum, 0)
change_column_default(:companies, :sold_sum, 0)
change_column_default(:companies, :ampliated_sum, 0)
change_column_default(:companies, :quantity_puchased, 0)
change_column_default(:companies, :quantity_sold, 0)
change_column_default(:companies, :quantity_ampliated, 0)
change_column_default(:companies, :shares_sum, 0)
change_column_default(:companies, :average_price, 0)
change_column_default(:companies, :share_price_global_currency, 0)
change_column_default(:companies, :invested_sum, 0)
change_column_default(:companies, :share_price_global_currency, 0)
change_column_default(:companies, :estimated_value_global_currency, 0)
change_column_default(:companies, :estimated_benefit_global_currency, 0)
change_column_default(:companies, :perc_estimated_benefit_global_currency, 0)
change_column_default(:companies, :average_price_origin_currency, 0)

  	
  end
end
