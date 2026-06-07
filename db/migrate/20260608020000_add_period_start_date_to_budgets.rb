class AddPeriodStartDateToBudgets < ActiveRecord::Migration[8.1]
  def up
    add_column :budgets, :period_start_date, :date

    # Migrasi data lama: period_start_date = Date(year, month, user.billing_start_day)
    # Ini harus dilakukan perlahan untuk existing data
    Budget.reset_column_information
    Budget.includes(:user).find_each do |budget|
      start_day = budget.user.billing_start_day
      
      # Handle if month is invalid or nil, though validations should prevent this
      m = budget.month || Date.today.month
      y = budget.year || Date.today.year
      
      # Determine safe start date
      # If start_day > days_in_month, we might get an error, so clamp it
      days_in_m = Date.new(y, m, -1).day
      safe_day = [start_day, days_in_m].min
      
      budget.update_columns(
        period_start_date: Date.new(y, m, safe_day)
      )
    end

    change_column_null :budgets, :period_start_date, false
    add_index :budgets, [:user_id, :category_id, :period_start_date],
              unique: true, name: 'idx_budgets_unique_period'
  end

  def down
    remove_index :budgets, name: 'idx_budgets_unique_period'
    remove_column :budgets, :period_start_date
  end
end
