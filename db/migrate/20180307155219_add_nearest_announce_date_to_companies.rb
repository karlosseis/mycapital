class AddNearestAnnounceDateToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :nearest_announce_date, :date
  end
end
