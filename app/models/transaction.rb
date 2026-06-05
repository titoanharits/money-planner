class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  belongs_to :source_pocket, class_name: "Pocket", optional: true
  belongs_to :destination_pocket, class_name: "Pocket", optional: true

  enum :transaction_type, { expense: 0, income: 1, transfer: 2 }

  validates :amount, numericality: { greater_than: 0 }
  validates :date, :user_id, :transaction_type, presence: true

  validate :validate_pocket_assignment
  validate :validate_category_presence

  scope :recent, -> { order(date: :desc, time: :desc) }
  scope :by_period, ->(range) { where(date: range) }
  scope :by_month, ->(date = Date.today) { 
    where(date: date.beginning_of_month..date.end_of_month) 
  }

  scope :expenses, -> { where(transaction_type: :expense) }
  scope :incomes, -> { where(transaction_type: :income) }
  scope :transfers, -> { where(transaction_type: :transfer) }

  def self.total_amount
    sum(:amount)
  end

  private

  def validate_pocket_assignment
    case transaction_type
    when "expense"
      errors.add(:source_pocket_id, "harus diisi untuk pengeluaran") if source_pocket_id.blank?
    when "income"
      errors.add(:destination_pocket_id, "harus diisi untuk pendapatan") if destination_pocket_id.blank?
    when "transfer"
      errors.add(:source_pocket_id, "harus diisi untuk transfer") if source_pocket_id.blank?
      errors.add(:destination_pocket_id, "harus diisi untuk transfer") if destination_pocket_id.blank?
      if source_pocket_id.present? && source_pocket_id == destination_pocket_id
        errors.add(:destination_pocket_id, "tidak boleh sama dengan kantong sumber")
      end
    end
  end

  def validate_category_presence
    # Semua tipe transaksi wajib punya category (termasuk transfer)
    errors.add(:category_id, "harus diisi") if category_id.blank?
  end
end
