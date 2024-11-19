class AddCheckConstraintToWallets < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TABLE wallets
      ADD CONSTRAINT balance_non_negative
      CHECK (balance >= 0);
    SQL
  end
end
