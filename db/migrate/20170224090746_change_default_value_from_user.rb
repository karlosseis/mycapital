class ChangeDefaultValueFromUser < ActiveRecord::Migration
  def change
  	change_column_default(:users, :permission_level, 1)
  end
end
