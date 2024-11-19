class StocksController < ApplicationController
  def index
    stocks = Stock.all
    render json: stocks
  end

  def show
    stock = Stock.find(params[:id])
    render json: stock
  end

  def create
    stock = Stock.new(stock_params)
    if stock.save
      render json: stock, status: :created
    else
      render json: { errors: stock.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    stock = Stock.find(params[:id])
    if stock.update(stock_params)
      render json: stock
    else
      render json: { errors: stock.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    stock = Stock.find(params[:id])
    stock.destroy
    head :no_content
  end

	def wallet
    stock = Stock.find(params[:id])
    render json: stock.wallet, methods: [:balance]
  end

  private

  def stock_params
    params.require(:stock).permit(:name, :shares)
  end
end
