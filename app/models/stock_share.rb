class StockShare < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :shares, numericality: { greater_than_or_equal_to: 0 }
end