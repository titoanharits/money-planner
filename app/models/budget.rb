class Budget < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :month, :year, presence: true
end
