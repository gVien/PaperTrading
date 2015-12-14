class RemoveWatchlistIdFromStocks < ActiveRecord::Migration
  def change
    remove_reference :stocks, :watchlist
  end
end
