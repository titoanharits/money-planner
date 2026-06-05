class CreateBalanceAdjustments < ActiveRecord::Migration[8.1]
  def change
    create_table :balance_adjustments do |t|
      t.references :pocket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.decimal :previous_balance, precision: 15, scale: 2, null: false
      t.decimal :new_balance, precision: 15, scale: 2, null: false
      t.string :note

      t.timestamps
    end
  end
end
