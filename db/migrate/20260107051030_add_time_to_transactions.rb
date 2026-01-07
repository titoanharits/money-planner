class AddTimeToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :time, :time
  end
end
