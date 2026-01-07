class Category < ApplicationRecord
  belongs_to :user
  has_many :budgets, dependent: :destroy
  # has_many :transactions # Untuk pengembangan nanti

  enum :category_type, { expense: 0, income: 1 }

  validates :name, :icon, :category_type, presence: true

  # Helper untuk mendapatkan budget bulan berjalan
  def current_budget(month = Date.today.month, year = Date.today.year)
    budgets.find_by(month: month, year: year)
  end
end
