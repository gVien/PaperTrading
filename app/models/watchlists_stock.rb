class WatchlistsStock < ActiveRecord::Base
  belongs_to :stock
  belongs_to :watchlist
end
