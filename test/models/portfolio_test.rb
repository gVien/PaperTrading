require 'test_helper'

class PortfolioTest < ActiveSupport::TestCase
  def setup
    @user = users(:gai)
    @position = @user.portfolios.build(symbol: "YHOO",
                                        company_name: "Yahoo Inc",
                                        quantity: 1000,
                                        average_price: 30.5)
  end

  test "should be valid" do
    assert(@position.valid?)
  end

  test "position symbol should be present" do
    @position.symbol = "   "  # this should be invalid
    assert_not(@position.valid?)  # test pass if @position.valid? is false, fail if true
  end

  test "position symbol should be unique" do
    goog = portfolios(:goog)
    duplicate_position = goog.dup
    duplicate_position.symbol = goog.symbol
    duplicate_position.save
    assert_not(duplicate_position.valid?, "#{duplicate_position.symbol} exists in the system.")
  end

  test "position quanity should be present" do
    @position.quantity = "   "
    assert_not(@position.valid?)
  end

  test "position average_price should be present" do
    @position.average_price = "   "  # this should be invalid
    assert_not(@position.valid?)
  end

  test "user id should be present in row" do
    @position.user_id = nil  # not valid
    assert_not(@position.valid?)
  end

  # symbol must be upper case
  test "symbol should be uppercase before saving to database" do
    new_position = @user.portfolios.build(symbol: "tsla", company_name: "Tesla Motor Inc.", quantity: 1000, average_price: 150.00)
    new_position.save
    assert_equal  "TSLA", new_position.reload.symbol
  end
end
