class AddSourceAndTargetWalletsToTransactionLogs < ActiveRecord::Migration[7.0]
  def change
    add_reference :transaction_logs, :source_wallet, foreign_key: { to_table: :wallets }
    add_reference :transaction_logs, :target_wallet, foreign_key: { to_table: :wallets }
  end
end
