class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.decimal :balance, precision: 15, scale: 2, default: 0.0, null: false
      t.references :walletable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
