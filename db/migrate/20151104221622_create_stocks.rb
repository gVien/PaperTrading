class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :company_name
      # t.references => t.string :watchlist_id
      t.references :watchlist, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :stocks, :symbol
  end
end
