Rails.application.routes.draw do
  # Authentication routes
  post 'users/sign_in',to: 'users#sign_in' # Sign-in
  delete 'users/sign_out', to: 'users#sign_out' # Sign-out

  resources :users, only: [:show, :update, :destroy] do
    member do
      get :wallet # View wallet balance
      get :stock_shares # View stock shares
      get :stocks # View all stocks available
      post :credit_wallet# Credit wallet
      post :debit_wallet # Debit wallet
      post :buy_stock# Buy stock
      post :sell_stock # Sell stock
      post :transfer # Transfer money between wallets
    end
  end
end
