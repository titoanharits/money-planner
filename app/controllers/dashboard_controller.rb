class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @health = current_user.financial_health_status
    @total_income = current_user.monthly_income
    @total_expense = current_user.monthly_expense
    @net_balance = current_user.monthly_net_balance
    @recent_transactions = current_user.transactions.recent.limit(5).includes(:category)
  end
end
