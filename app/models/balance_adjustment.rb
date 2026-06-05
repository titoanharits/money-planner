class BalanceAdjustment < ApplicationRecord
  belongs_to :pocket
  belongs_to :user

  validates :amount, :previous_balance, :new_balance, presence: true
  validates :amount, numericality: { other_than: 0 }

  scope :recent, -> { order(created_at: :desc) }
end
