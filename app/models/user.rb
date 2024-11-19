require 'securerandom'

class User < ApplicationRecord
  has_one :wallet, as: :walletable, dependent: :destroy
	has_many :stock_shares
  has_many :stocks, through: :stock_shares
	belongs_to :team

	validates :username, presence: true, uniqueness: true
	
  after_create :initialize_wallet

	# Use bcrypt for password encryption
  has_secure_password

  # Generate a secure token for authentication
  before_create :generate_token

	def buy_stock(stock, shares)
    ActiveRecord::Base.transaction do
      stock_share = stock_shares.find_or_initialize_by(stock: stock)
      total_cost = stock.last_price * shares

      raise "Insufficient funds" if wallet.balance < total_cost

      wallet.debit(total_cost)
      stock_share.shares = stock_share.shares.to_i + shares
      stock_share.save!
    end
  end

  def sell_stock(stock, shares)
    ActiveRecord::Base.transaction do
      stock_share = stock_shares.find_by(stock: stock)
      raise "No shares owned" unless stock_share
      raise "Not enough shares" if stock_share.shares < shares

      total_earnings = stock.last_price * shares

      wallet.credit(total_earnings)
      stock_share.shares -= shares
      stock_share.shares.zero? ? stock_share.destroy! : stock_share.save!
    end
  end

  def stock_balance(stock)
    stock_shares.find_by(stock: stock)&.shares || 0
  end

  private

  def generate_token
    self.token = SecureRandom.hex(20)
  end

  def initialize_wallet
    create_wallet!
  end
end
