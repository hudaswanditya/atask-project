require 'bigdecimal'
require 'bigdecimal/util'

class Wallet < ApplicationRecord
  has_many :transaction_logs, dependent: :destroy

  # Credit money to the wallet using BigDecimal for precision
  def credit(amount)
    # Convert amount to a BigDecimal using a string representation
    amount = BigDecimal(amount.to_s) # This avoids issues with float precision
  
    raise ArgumentError, "Amount must be positive" if amount <= 0
  
    transaction_logs.create!(
      transaction_type: "credit",
      amount: amount,
      target_wallet: self
    )
  end

  # Debit money from the wallet
  def debit(amount)
    # Convert amount to a BigDecimal using a string representation
    amount = BigDecimal(amount.to_s) # This avoids issues with float precision
  
    raise ArgumentError, "Amount must be positive" if amount <= 0

    raise ActiveRecord::Rollback, "Insufficient balance" if amount > balance

    transaction_logs.create!(
      transaction_type: "debit",
      amount: amount,
      source_wallet: self
    )
  end

  # Transfer money from this wallet to another wallet
  def transfer(amount, target_wallet)
    amount = BigDecimal(amount.to_s) # This avoids issues with float precision
    raise ArgumentError, "Target wallet is required" if target_wallet.nil?
    raise ArgumentError, "Amount must be positive" if amount <= 0
    raise ActiveRecord::Rollback, "Insufficient balance" if amount > balance

    TransactionLog.create!(
      transaction_type: "transfer",
      amount: amount,
      source_wallet: self,
      target_wallet: target_wallet
    )
  end

  # Calculate balance dynamically
  def balance
    transaction_logs.sum("CASE transaction_type WHEN 'credit' THEN amount WHEN 'transfer' THEN CASE WHEN source_wallet_id = #{id} THEN -amount ELSE amount END ELSE -amount END").to_f
  end
end
