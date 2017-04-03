class RemoveNameFromReferenceWeb < ActiveRecord::Migration
  def change
    remove_column :reference_webs, :name, :text
  end
end
