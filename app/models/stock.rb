require 'bigdecimal'
require 'bigdecimal/util'

class Stock < ApplicationRecord
  has_many :stock_shares
  has_many :users, through: :stock_shares

  # Sync stock data with the API
  def self.sync_from_api
    client = LatestStockPrice::Client.new
    stocks_data = client.price_all

    stocks_data.each do |stock_data|
      stock = find_or_initialize_by(symbol: stock_data["symbol"])
      stock.update(
        name: stock_data["identifier"],
        last_price: stock_data["lastPrice"].to_d, # Convert to BigDecimal
        day_high: stock_data["dayHigh"].to_d,    # Convert to BigDecimal
        day_low: stock_data["dayLow"].to_d,      # Convert to BigDecimal
        year_high: stock_data["yearHigh"].to_d,  # Convert to BigDecimal
        year_low: stock_data["yearLow"].to_d,    # Convert to BigDecimal
        updated_at: Time.zone.now
      )
    end
  rescue StandardError => e
    Rails.logger.error("Failed to sync stocks: #{e.message}")
  end

  # Fetch the latest price for a single stock
  def fetch_latest_price
    client = LatestStockPrice::Client.new
    price = client.price(symbol)
    update(last_price: price.to_d, updated_at: Time.zone.now) if price
    price
  rescue StandardError => e
    Rails.logger.error("Failed to fetch latest price for #{symbol}: #{e.message}")
    nil
  end
end
