class AddBillingStartDayToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :billing_start_day, :integer, default: 1, null: false
  end
end
