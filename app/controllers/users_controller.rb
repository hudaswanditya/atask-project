class UsersController < ApplicationController
  before_action :authenticate_user, except: [:sign_in, :sign_out, :create]
	before_action :set_user, except: [:index, :create, :sign_in, :sign_out]

  # Sign-in
  def sign_in
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password]) # bcrypt's `authenticate` method checks the password
      token = SecureRandom.hex(16) # Generate a secure token for the session
      user.update!(token: token)   # Store the token in the database
      render json: { message: "Sign-in successful", token: token }, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  # Sign-out
  def sign_out
    user = User.find_by(token: params[:token])

    if user
      user.update!(token: SecureRandom.hex(16))  # Regenerate the token to invalidate the session
      render json: { message: "Sign-out successful" }, status: :ok
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end

  # All other actions can use `@current_user` for authenticated operations...

	# Index (for listing users of a team)
  def index
    team = Team.find(params[:team_id])
    users = team.users
    render json: users
  end

  # Show (for showing a specific user)
  def show
    render json: @user
  end

	# Get all stocks owned by a user
	def stock_shares
		render json: @user.stocks
	end

	def stocks
		render json: Stock.all
	end

  # Create a new user
  def create
    team = Team.find(params[:team_id])
    user = team.users.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Update user
  def update
    if @user.update(user_params)
      render json: user
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Destroy user
  def destroy
    @user.destroy
    head :no_content
  end

  # Wallet (view the user's wallet balance)
  def wallet
    render json: @user.wallet, methods: [:balance]
  end

  # Credit wallet
  def credit_wallet
    amount = params[:amount]

    begin
      @user.wallet.credit(amount)
      render json: { message: "Wallet credited successfully", balance: @user.wallet.balance }, status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # Debit wallet
  def debit_wallet
    amount = params[:amount]

    begin
      @user.wallet.debit(amount)
      render json: { message: "Wallet debited successfully", balance: @user.wallet.balance }, status: :ok
    rescue ArgumentError, ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # Buy stock
  def buy_stock
    stock = Stock.find(params[:stock_id])
    shares_to_buy = params[:shares].to_i

    begin
      @user.wallet.buy_stock(stock, shares_to_buy)
      render json: {
        message: "Stock purchased successfully",
        user_balance: user.wallet.balance,
        stock_shares: stock.shares
      }, status: :ok
    rescue ArgumentError, ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # Sell stock
  def sell_stock
    stock = Stock.find(params[:stock_id])
    shares_to_sell = params[:shares].to_i

    begin
      @user.wallet.sell_stock(stock, shares_to_sell)
      render json: {
        message: "Stock sold successfully",
        user_balance: @user.wallet.balance,
        stock_shares: stock.shares
      }, status: :ok
    rescue ArgumentError, ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # Transfer money between wallets
  def transfer
    target_wallet = Wallet.find(params[:target_wallet_id])
    amount = params[:amount].to_d # Use BigDecimal for precision

    begin
      @user.wallet.transfer(amount, target_wallet)
      render json: {
        message: "Transfer successful",
        user_balance: @user.wallet.balance,
        target_balance: target_wallet.balance
      }, status: :ok
    rescue ArgumentError, ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

	def set_user
		@user = User.find(params[:id])
	end

  def user_params
    params.require(:user).permit(:username, :password, :team_id)
  end

	def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last

    @current_user = User.find_by(token: token)

    unless @current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
