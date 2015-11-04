require 'test_helper'

class StockTest < ActiveSupport::TestCase
  def setup
    @watchlist = watchlists(:watchlist1)
    @stock = @watchlist.stocks.build(symbol: "TSLA", company_name: "Tesla Motor")
  end

  # test criteria
  # symbol must be valid and present
  # symbol must be upper case
  # company_name must be valid and present
  # stock must belong to watchlist id
  # watchlist id must be present
end
