class AddNameToReferenceWebs < ActiveRecord::Migration
  def change
    add_column :reference_webs, :name, :string
  end
end
