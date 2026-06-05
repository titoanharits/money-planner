class AddTransactionTypeAndPocketsToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :transaction_type, :integer, default: 0, null: false
    add_reference :transactions, :source_pocket, foreign_key: { to_table: :pockets }, null: true
    add_reference :transactions, :destination_pocket, foreign_key: { to_table: :pockets }, null: true
    change_column_null :transactions, :category_id, true
  end
end
