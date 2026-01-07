class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [ :edit, :update, :show, :destroy ]

  def index
    @categories = current_user.categories.where(category_type: 0).includes(:budgets).order(name: :asc)
    @total_budget = current_user.budgets.where(month: Date.today.month, year: Date.today.year).sum(:amount)

    # Placeholder untuk total pengeluaran (akan dihubungkan saat modul Transaction selesai)
    @total_spent = 0
  end

  def new
    @category = current_user.categories.new
  end

  def create
    @category = current_user.categories.new(category_params)
    @category.category_type = 0 # Set default ke expense
    
    if @category.save
      # Jika budget diisi, buat record budget untuk bulan ini
      if params[:initial_budget].present?
        @category.budgets.create!(
          user: current_user,
          amount: params[:initial_budget],
          month: Date.today.month,
          year: Date.today.year
        )
      end
      redirect_to categories_path, notice: "Kategori berhasil dibuat!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      # Update atau Buat Budget bulan ini jika kategori adalah expense
      if @category.expense? && params[:initial_budget].present?
        budget = @category.budgets.find_or_initialize_by(
          user: current_user,
          month: Date.today.month,
          year: Date.today.year
          )
          budget.amount = params[:initial_budget]
          budget.save
      elsif @category.income?
          # Hapus budget bulan ini jika kategori berubah jadi income
          @category.budgets.where(month: Date.today.month, year: Date.today.year).destroy_all
      end

        redirect_to categories_path, notice: "Category updated successfully!"
    else
        render :edit, status: :unprocessable_entity
    end
  end

    def show
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

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :icon, :color, :category_type)
  end
end
