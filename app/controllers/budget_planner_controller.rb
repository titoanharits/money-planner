class BudgetPlannerController < ApplicationController
  before_action :authenticate_user!

  def index
    @page_title = "Budget Planner"

    # Periode: dari param atau default hari ini
    if params[:period].present?
      ref_date = Date.parse(params[:period])
    else
      ref_date = Date.today
    end

    @billing_period = current_user.current_billing_period(ref_date)
    @period_start = @billing_period.first
    @period_end = @billing_period.last

    # Navigasi periode
    @prev_period_start = current_user.current_billing_period(@period_start - 1.day).first
    next_candidate = current_user.current_billing_period(@period_end + 1.day).first
    @next_period_start = next_candidate <= current_user.period_start_for ? next_candidate : nil
    @is_current_period = @period_start == current_user.period_start_for

    # Data
    @expense_categories = current_user.categories.expense.order(:name)
    @budgets_map = current_user.budgets.for_period(@period_start).index_by(&:category_id)
    @total_allocated = current_user.budgets.for_period(@period_start).sum(:amount)
    @total_income = current_user.monthly_income(ref_date)
    @total_spent = current_user.monthly_expense(ref_date)
    @category_spent_map = current_user.expenses_by_category_map(ref_date)
  end

  def update
    period_start = Date.parse(params[:period_start])

    params[:budgets]&.each do |category_id, amount|
      category = current_user.categories.find_by(id: category_id)
      next unless category

      budget = category.budgets.find_or_initialize_by(
        user: current_user,
        period_start_date: period_start
      )

      if amount.to_f > 0
        budget.update!(
          amount: amount.to_f,
          month: period_start.month,
          year: period_start.year
        )
      else
        budget.destroy if budget.persisted?
      end
    end

    redirect_to budget_planner_path(period: period_start),
                notice: "Budget berhasil disimpan!"
  end
end
