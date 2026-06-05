class Pocket < ApplicationRecord
  belongs_to :user

  has_many :outgoing_transactions, class_name: "Transaction",
           foreign_key: :source_pocket_id, dependent: :restrict_with_error
  has_many :incoming_transactions, class_name: "Transaction",
           foreign_key: :destination_pocket_id, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }

  # Saldo = total income masuk + transfer masuk - total expense keluar - transfer keluar
  def current_balance
    total_incoming - total_outgoing
  end

  private

  def total_incoming
    incoming_transactions.sum(:amount)
  end

  def total_outgoing
    outgoing_transactions.sum(:amount)
  end
end
