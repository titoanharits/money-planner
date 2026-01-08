class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [ :edit, :update, :show, :destroy ]
  before_action :set_page_title

  def index
    @expense_categories = current_user.categories.expense.includes(:budgets)
    @income_categories = current_user.categories.income

    @total_budget = current_user.total_monthly_budget
    @total_spent = current_user.monthly_expense # Total dari transaksi expense
    @total_income = current_user.monthly_income  # Total dari transaksi income

    @category_spent_map = current_user.expenses_by_category_map
    # Map untuk income (pemasukan per kategori)
    @category_income_map = current_user.transactions.by_month.incomes.group(:category_id).sum(:amount)
  end

  def new
    @category = current_user.categories.new
  end

  def create
    @category = current_user.categories.new(category_params)
    if @category.save
      @category.update_monthly_budget(params[:initial_budget], current_user)
      redirect_to categories_path, notice: "Kategori berhasil dibuat!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      @category.update_monthly_budget(params[:initial_budget], current_user)
      redirect_to categories_path, notice: "Category updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
    @transactions = @category.transactions.by_month.recent
    @transactions_by_date = @transactions.group_by(&:date)

    @total_spent = @category.total_spent_in_month
  end

  def destroy
    if @category.destroy
      # Menggunakan flash notice yang sudah kita beri style border hitam sebelumnya
      redirect_to categories_path, notice: "Category was successfully deleted."
    else
      redirect_to categories_path, alert: "Failed to delete category."
    end
  end

  private
  def set_page_title
    @page_title = "My Budget"
  end

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :icon, :color, :category_type)
  end
end
