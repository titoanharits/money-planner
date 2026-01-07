class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :transactions, dependent: :destroy

  SUPPORTED_CURRENCIES = [
    ["IDR - Rupiah Indonesia", "IDR"],
    ["USD - US Dollar", "USD"],
    ["SGD - Singapore Dollar", "SGD"],
    ["EUR - Euro", "EUR"]
  ].freeze

  validates :currency, presence: true, inclusion: { in: SUPPORTED_CURRENCIES.map(&:last) }
end
