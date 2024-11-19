class Team < ApplicationRecord
  has_one :wallet, as: :walletable, dependent: :destroy
	has_many :users, dependent: :destroy
	
	validates :name, presence: true, uniqueness: true

  after_create :initialize_wallet

  private

  def initialize_wallet
    create_wallet!
  end
end
