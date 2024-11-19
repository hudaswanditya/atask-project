class CreateTransactionLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_logs do |t|
      t.references :wallet, null: false, foreign_key: true
      t.string :transaction_type
      t.decimal :amount, precision: 15, scale: 2, null: false

      t.timestamps
    end
  end
end
