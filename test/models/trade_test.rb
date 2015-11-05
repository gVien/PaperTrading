require 'test_helper'

class TradeTest < ActiveSupport::TestCase
  def setup
    @user = users(:gai)
    @trade = @user.trades.build(symbol_traded: "TSLA", shares_traded: 250, total_amount_traded: 10.50)
  end

  # create new trade is valid
  test "should be valid" do
    assert(@trade.valid?)
  end

  # symbol traded is valid (present)
  test "symbol traded should be valid" do
    @trade.symbol_traded = " "
    assert_not @trade.valid?
  end

  # shares_traded is valid (present)
  test "shares_traded should be valid" do
    @trade.shares_traded = " "
    assert_not @trade.valid?
  end

  # total_amount_traded is valid (present)
  test "total_amount_traded should be valid" do
    @trade.total_amount_traded = " "
    assert_not @trade.valid?
  end

  # trade has a valid user id
  test "user id should be present in row" do
    @trade.user_id = nil  # not valid
    assert_not(@trade.valid?)
  end

  # symbol_traded should be uppercase before saving
  test "symbol traded should be uppercase before saving to database" do
    new_trade= @user.trades.build(symbol_traded: "yhoo", shares_traded: 1500, total_amount_traded: 30.50)
    new_trade.save
    assert_equal  "YHOO", new_trade.reload.symbol_traded
  end
end
