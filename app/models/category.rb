class Category < ApplicationRecord
  belongs_to :user
  has_many :budgets, dependent: :destroy
  has_many :transactions, dependent: :restrict_with_error

  enum :category_type, { expense: 0, income: 1, transfer: 2 }

  validates :name, :icon, :category_type, presence: true
  validate :cannot_modify_system_category, on: :update

  scope :user_editable, -> { where(system_default: false) }
  scope :system_categories, -> { where(system_default: true) }

  before_destroy :prevent_system_category_deletion

  def current_budget_for(user, date = Date.today)
    period_start = user.period_start_for(date)
    budgets.find_by(period_start_date: period_start)
  end

  def total_spent_in_month(date = Date.today)
    # Gunakan current_billing_period dari user jika memungkinkan
    period = user ? user.current_billing_period(date) : (date.beginning_of_month..date.end_of_month)
    transactions.where(date: period).sum(:amount)
  end

  def update_monthly_budget(amount, user)
    return if amount.blank?
    
    period_start = user.period_start_for
    if expense?
      budget = budgets.find_or_initialize_by(
        user: user,
        period_start_date: period_start
      )
      budget.update(amount: amount, month: period_start.month, year: period_start.year)
    else
      # Hapus budget jika kategori berubah jadi income atau transfer
      budgets.where(period_start_date: period_start).destroy_all
    end
  end

  private

  def cannot_modify_system_category
    if system_default? && (name_changed? || category_type_changed? || icon_changed?)
      errors.add(:base, "Kategori sistem tidak bisa diubah")
    end
  end

  def prevent_system_category_deletion
    if system_default?
      errors.add(:base, "Kategori sistem tidak bisa dihapus")
      throw(:abort)
    end
  end
end
