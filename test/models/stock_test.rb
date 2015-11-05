require 'test_helper'

class StockTest < ActiveSupport::TestCase
  def setup
    @watchlist = watchlists(:watchlist1)
    @stock = @watchlist.stocks.build(symbol: "TSLA", company_name: "Tesla Motor")
  end

  # test criteria
  # creating row should be valid
  test "should be valid" do
    assert @stock.valid?
  end

  # symbol must be valid and present
  test "symbol should be valid (present)" do
    @stock.symbol = "    "
    assert_not @stock.valid?   #pass if
  end

  # company name should valid
  test "company name should be valid" do
    @stock.company_name = "   "
    assert_not @stock.valid?
  end

  # symbol must be upper case
  test "symbol should be uppercase before saving to database" do
    new_stock = @watchlist.stocks.build(symbol: "goog", company_name: "Alphabet Inc.")
    new_stock.save
    assert_equal  "GOOG", new_stock.reload.symbol
  end

  # stock must belong to watchlist id
  # watchlist id must be present
  test "watchlist id must be present" do
    @stock.watchlist_id = nil
    assert_not @stock.valid?
  end
end
