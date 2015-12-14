class CreateWatchlistsStocks < ActiveRecord::Migration
  def change
    create_table :watchlists_stocks do |t|
      t.references :watchlist, index: true, foreign_key: true
      t.references :stock, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
