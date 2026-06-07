class Budget < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :month, :year, :period_start_date, presence: true
  validates :category_id, uniqueness: { scope: [:user_id, :period_start_date] }

  scope :for_period, ->(start_date) { where(period_start_date: start_date) }
  scope :for_date, ->(user, date) {
    period_start = user.current_billing_period(date).first
    where(period_start_date: period_start)
  }
end
