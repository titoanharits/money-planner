class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category

  delegate :category_type, to: :category, allow_nil: true
  
  validates :amount, numericality: { greater_than: 0 }
  validates :date, :category_id, :user_id, presence: true

  scope :recent, -> { order(date: :desc, time: :desc) }
  scope :by_month, ->(date = Date.today) { 
    where(date: date.beginning_of_month..date.end_of_month) 
  }

  scope :expenses, -> { joins(:category).where(categories: { category_type: 0 }) }
  scope :incomes, -> { joins(:category).where(categories: { category_type: 1 }) }

  def self.total_amount
    sum(:amount)
  end
end
