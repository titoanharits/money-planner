class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :pockets, dependent: :destroy
  has_many :balance_adjustments, dependent: :destroy

  SUPPORTED_CURRENCIES = [
    ["IDR - Rupiah Indonesia", "IDR"],
    ["USD - US Dollar", "USD"],
    ["SGD - Singapore Dollar", "SGD"],
    ["EUR - Euro", "EUR"]
  ].freeze

  validates :currency, presence: true, inclusion: { in: SUPPORTED_CURRENCIES.map(&:last) }
  
  validates :billing_start_day, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 28
  }, allow_nil: true

  def billing_start_day
    read_attribute(:billing_start_day) || 1
  end

  # Periode billing berdasarkan setting user
  def current_billing_period(reference_date = Date.today)
    start_day = billing_start_day
    if reference_date.day >= start_day
      period_start = reference_date.change(day: start_day)
      period_end = (period_start >> 1) - 1.day
    else
      period_start = (reference_date << 1).change(day: start_day)
      period_end = reference_date.change(day: start_day) - 1.day
    end
    period_start..period_end
  end

  def monthly_income(date = Date.today)
    period = current_billing_period(date)
    transactions.by_period(period).incomes.total_amount
  end

  def monthly_expense(date = Date.today)
    period = current_billing_period(date)
    transactions.by_period(period).expenses.total_amount
  end

  def monthly_net_balance(date = Date.today)
    monthly_income(date) - monthly_expense(date)
  end

  def total_pocket_balance
    pockets.sum { |p| p.current_balance }
  end

  def total_monthly_budget(date = Date.today)
    budgets.where(month: date.month, year: date.year).sum(:amount)
  end

  def expenses_by_category_map(date = Date.today)
    period = current_billing_period(date)
    transactions.by_period(period)
                .expenses
                .group(:category_id)
                .sum(:amount)
  end

  # Logika Financial Health (Business Logic)
  def financial_health_status(date = Date.today)
    income = monthly_income(date)
    expense = monthly_expense(date)

    # Formula: $$ \text{Ratio} = \left( \frac{\text{Expense}}{\text{Income}} \right) \times 100 $$
    percent = income > 0 ? ((expense.to_f / income) * 100).to_i : 0

    status, color, advice = case percent
      when 0..40    then ["Excellent", "bg-emerald-300", "Sangat ideal! Anda menyisihkan lebih dari 60% pendapatan."]
      when 41..60   then ["Healthy", "bg-sky-300", "Kondisi stabil. Pengeluaran Anda terkendali."]
      when 61..90   then ["Warning", "bg-yellow-300", "Hati-hati, pengeluaran mulai mendominasi pendapatan."]
      when 91..100  then ["Living Edge", "bg-orange-400", "Berbahaya! Anda hidup dari gaji ke gaji."]
      else               ["Deficit", "bg-rose-400", "Kritis! Pengeluaran melebihi pemasukan."]
    end

    { percent: percent, status: status, color: color, advice: advice }
  end

  def needs_onboarding?
    categories.empty? && pockets.empty?
  end
end
