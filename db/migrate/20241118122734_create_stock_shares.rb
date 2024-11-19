class CreateStockShares < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_shares do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :shares

      t.timestamps
    end
  end
end
