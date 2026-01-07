class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category

  delegate :category_type, to: :category, allow_nil: true
  
  validates :amount, numericality: { greater_than: 0 }
  validates :date, :category_id, :user_id, presence: true

  scope :recent, -> { order(date: :desc, created_at: :desc) }
end
