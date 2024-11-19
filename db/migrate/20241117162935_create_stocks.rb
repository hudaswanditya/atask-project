class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :name
      t.decimal :last_price
      t.decimal :day_high
      t.decimal :day_low
      t.decimal :year_high
      t.decimal :year_low

      t.timestamps
    end
  end
end
