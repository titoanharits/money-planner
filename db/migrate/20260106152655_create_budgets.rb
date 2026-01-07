class CreateBudgets < ActiveRecord::Migration[8.1]
  def change
    create_table :budgets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.decimal :amount, precision: 15, scale: 2
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
