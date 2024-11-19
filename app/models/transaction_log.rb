class TransactionLog < ApplicationRecord
  belongs_to :wallet
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  validates :transaction_type, presence: true, inclusion: { in: %w[credit debit transfer] }
  validates :amount, numericality: { greater_than: 0 }

  validate :validate_source_and_target_wallets

  private

  # Validation for source and target wallets based on transaction type
  def validate_source_and_target_wallets
    case transaction_type
    when "credit"
      errors.add(:source_wallet, "must be nil for credit transactions") if source_wallet.present?
      errors.add(:target_wallet, "is required for credit transactions") if target_wallet.nil?
    when "debit"
      errors.add(:source_wallet, "is required for debit transactions") if source_wallet.nil?
      errors.add(:target_wallet, "must be nil for debit transactions") if target_wallet.present?
    when "transfer"
      errors.add(:source_wallet, "is required for transfer transactions") if source_wallet.nil?
      errors.add(:target_wallet, "is required for transfer transactions") if target_wallet.nil?
      errors.add(:base, "Source and target wallets cannot be the same") if source_wallet == target_wallet
    end
  end
end
