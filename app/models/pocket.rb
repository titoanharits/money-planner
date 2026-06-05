class Pocket < ApplicationRecord
  belongs_to :user

  has_many :balance_adjustments, dependent: :destroy

  has_many :outgoing_transactions, class_name: "Transaction",
           foreign_key: :source_pocket_id, dependent: :restrict_with_error
  has_many :incoming_transactions, class_name: "Transaction",
           foreign_key: :destination_pocket_id, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }

  # Saldo = total income masuk + transfer masuk - total expense keluar - transfer keluar + total adjustment
  def current_balance
    total_incoming - total_outgoing + total_adjustments
  end

  def adjust_balance!(new_balance, current_user, note: nil)
    previous = current_balance
    difference = new_balance - previous
    
    return true if difference.zero?

    balance_adjustments.create!(
      user: current_user,
      amount: difference,
      previous_balance: previous,
      new_balance: new_balance,
      note: note
    )
  end

  def zero_balance!(current_user, note: "Reset ke Rp 0")
    adjust_balance!(0, current_user, note: note)
  end

  private

  def total_incoming
    incoming_transactions.sum(:amount)
  end

  def total_outgoing
    outgoing_transactions.sum(:amount)
  end

  def total_adjustments
    balance_adjustments.sum(:amount)
  end
end
