require 'test_helper'
require 'helpers/trade_king_webmock_helper_test'

class TradeKingTest < ActiveSupport::TestCase
  include TradeKingWebmockHelperTest
  @@trade_king ||= TradeKing.new

  test '#get_quote returns stock quotes json' do
    symbol = 'YHOO'
    stub_get_quote_request(symbol)
    quote = @@trade_king.get_quote(symbol)

    assert_equal quote[:symbol], symbol
  end

  # test '' do
  #     toplosers = @trade_king.get_toplosers
  #
  #     assert(toplosers.length > 0) # expect results to have length of more than 0
  # end
  #
  # test '' do
  #     top_pct_losers = @trade_king.get_top_pct_losers
  #
  #     assert(top_pct_losers.length > 0) # expect results to have length of more than 0
  # end
  #
  # test '' do
  #     topvolume = @trade_king.get_topvolume
  #
  #     assert(topvolume.length > 0) # expect results to have length of more than 0
  # end
  #
  # test '' do
  #     topactive = @trade_king.get_topactive
  #
  #     assert(topactive.length > 0) # expect results to have length of more than 0
  # end
  #
  # test '' do
  #     topgainers = @trade_king.get_topgainers
  #
  #     assert(topgainers.length > 0) # expect results to have length of more than 0
  # end
  #
  # test '' do
  #     top_pct_gainers = @trade_king.get_top_pct_gainers
  #
  #     assert(top_pct_gainers.length > 0) # expect results to have length of more than 0
  # end
end
