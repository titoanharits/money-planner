class Category < ApplicationRecord
  belongs_to :user
  has_many :budgets, dependent: :destroy
  has_many :transactions, dependent: :destroy

  enum :category_type, { expense: 0, income: 1 }

  validates :name, :icon, :category_type, presence: true

  # Helper untuk mendapatkan budget bulan berjalan
  def current_budget(month = Date.today.month, year = Date.today.year)
    budgets.find_by(month: month, year: year)
  end

  def total_spent_in_month(date = Date.today)
    transactions.where(date: date.beginning_of_month..date.end_of_month).sum(:amount)
  end

  def update_monthly_budget(amount, user)
    return if amount.blank?
    
    if expense?
      budget = budgets.find_or_initialize_by(
        user: user,
        month: Date.today.month,
        year: Date.today.year
      )
      budget.update(amount: amount)
    else
      # Hapus budget jika kategori berubah jadi income
      budgets.where(month: Date.today.month, year: Date.today.year).destroy_all
    end
  end
end
