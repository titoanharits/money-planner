class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount
      t.string :description
      t.date :date
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
