class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [ :edit, :update, :show, :destroy ]
  before_action :set_page_title

  def index
    @expense_categories = current_user.categories.expense.includes(:budgets)
    @income_categories = current_user.categories.income
    @transfer_categories = current_user.categories.transfer

    @total_budget = current_user.total_monthly_budget
    @total_spent = current_user.monthly_expense
    @total_income = current_user.monthly_income

    @category_spent_map = current_user.expenses_by_category_map
    
    period = current_user.current_billing_period
    @category_income_map = current_user.transactions.by_period(period).incomes.group(:category_id).sum(:amount)
  end

  def new
    @category = current_user.categories.new
  end

  def create
    @category = current_user.categories.new(category_params)
    @category.system_default = false # ensure user cannot create system category
    
    if @category.save
      redirect_to categories_path, notice: "Kategori berhasil dibuat!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Category updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
    # period logic updated in Category model
    @transactions = @category.transactions.by_period(current_user.current_billing_period).recent
    @transactions_by_date = @transactions.group_by(&:date)

    @total_spent = @category.total_spent_in_month
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, notice: "Category was successfully deleted."
    else
      redirect_to categories_path, alert: @category.errors.full_messages.to_sentence || "Failed to delete category."
    end
  end

  private
  def set_page_title
    @page_title = "Categories"
  end

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :icon, :color, :category_type)
  end
end
