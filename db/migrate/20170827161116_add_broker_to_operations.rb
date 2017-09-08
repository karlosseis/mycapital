class AddBrokerToOperations < ActiveRecord::Migration
  def change
    add_reference :operations, :broker, index: true, foreign_key: true, :default => 1
  end
end
