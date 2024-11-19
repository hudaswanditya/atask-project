require "net/http"
require "json"
require "uri"

module LatestStockPrice
  class Client
    BASE_URL = "https://latest-stock-price.p.rapidapi.com/any"

    # Set your RapidAPI key here or pass it during initialization
    API_KEY = ENV["RAPIDAPI_KEY"] || "fb5d410974mshf9b1e9b714c9983p11817cjsnc4a799fc7a61"

    def initialize
      @uri = URI(BASE_URL)
    end

    # Fetch the price for a specific stock by symbol
    def price(symbol)
      response = fetch_data
      stock = response.find { |entry| entry["symbol"] == symbol }
      stock ? stock["lastPrice"] : nil
    rescue StandardError => e
      handle_error(e)
    end

    # Fetch prices for a list of stock symbols
    def prices(symbols)
      response = fetch_data
      response.select { |entry| symbols.include?(entry["symbol"]) }
    rescue StandardError => e
      handle_error(e)
    end

    # Fetch prices for all stocks
    def price_all
      fetch_data
    rescue StandardError => e
      handle_error(e)
    end

    private

    # Perform the API request and return the parsed response
    def fetch_data
      request = build_request
      response = send_request(request)

      # Parse and return JSON response
      JSON.parse(response.body)
    end

    # Build the API request with headers
    def build_request
      request = Net::HTTP::Get.new(@uri)
      request["X-RapidAPI-Host"] = "latest-stock-price.p.rapidapi.com"
      request["X-RapidAPI-Key"] = API_KEY
      request
    end

    # Send the HTTP request
    def send_request(request)
      Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) do |http|
        http.request(request)
      end
    end

    # Handle errors gracefully
    def handle_error(error)
      puts "Error: #{error.message}"
      nil
    end
  end
end
