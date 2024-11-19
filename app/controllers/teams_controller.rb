class TeamsController < ApplicationController
  before_action :authenticate_user

  # List all teams
  def index
    teams = Team.all
    render json: teams
  end

  # Show specific team details
  def show
    team = Team.find(params[:id])
    render json: team, include: :users
  end

  # Create a new team
  def create
    team = Team.new(team_params)
    if team.save
      render json: team, status: :created
    else
      render json: { errors: team.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Update a team
  def update
    team = Team.find(params[:id])
    if team.update(team_params)
      render json: team
    else
      render json: { errors: team.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Delete a team
  def destroy
    team = Team.find(params[:id])
    team.destroy
    head :no_content
  end

  # Fetch wallet details of a team
  def wallet
    team = Team.find(params[:id])
    render json: team.wallet, methods: [:balance]
  end

  # Credit the team's wallet
  def credit_wallet
    team = Team.find(params[:id])
    amount = params[:amount]

    begin
      team.wallet.credit(amount)
      render json: { message: "Wallet credited successfully", balance: team.wallet.balance }, status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # Debit the team's wallet
  def debit_wallet
    team = Team.find(params[:id])
    amount = params[:amount]

    begin
      team.wallet.debit(amount)
      render json: { message: "Wallet debited successfully", balance: team.wallet.balance }, status: :ok
    rescue ArgumentError, ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # Transfer funds from team's wallet to another wallet
  def transfer
    team = Team.find(params[:id])
    target_wallet = Wallet.find(params[:target_wallet_id])
    amount = params[:amount].to_d # Use BigDecimal for precision

    begin
      team.wallet.transfer(amount, target_wallet)
      render json: {
        message: "Transfer successful",
        team_balance: team.wallet.balance,
        target_balance: target_wallet.balance
      }, status: :ok
    rescue ArgumentError, ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters for team
  def team_params
    params.require(:team).permit(:name)
  end

  # Authentication method
  def authenticate_user
    token = request.headers['Authorization']

    unless token && User.find_by(token: token)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
