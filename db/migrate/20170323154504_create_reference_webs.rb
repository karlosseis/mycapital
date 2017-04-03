class CreateReferenceWebs < ActiveRecord::Migration
  def change
    create_table :reference_webs do |t|
      t.text :name
      t.string :url
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
