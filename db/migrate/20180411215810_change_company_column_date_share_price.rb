class ChangeCompanyColumnDateSharePrice < ActiveRecord::Migration
  def change
  	change_column :companies, :date_share_price, :datetime
  end
end
