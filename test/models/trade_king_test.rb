require 'test_helper'

class TradeKingTest < ActiveSupport::TestCase
  test "simple tests to ensure TradeKing API endpoints returns data" do
    quote = TradeKing.get_quote("YHOO")
    assert_equal quote[:symbol], "YHOO"
    toplosers = TradeKing.get_toplosers
    assert(toplosers.length > 0) # expect results to have length of more than 0
    top_pct_losers = TradeKing.get_top_pct_losers
    assert(top_pct_losers.length > 0) # expect results to have length of more than 0
    topvolume = TradeKing.get_topvolume
    assert(topvolume.length > 0) # expect results to have length of more than 0
    topactive = TradeKing.get_topactive
    assert(topactive.length > 0) # expect results to have length of more than 0
    topgainers = TradeKing.get_topgainers
    assert(topgainers.length > 0) # expect results to have length of more than 0
    top_pct_gainers = TradeKing.get_top_pct_gainers
    assert(top_pct_gainers.length > 0) # expect results to have length of more than 0
    top_active = TradeKing.get_top_active_gainers_by_dollar_value
    assert(top_active.length > 0) # expect results to have length of more than 0
  end
end
