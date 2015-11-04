require 'test_helper'

class WatchlistTest < ActiveSupport::TestCase
  def setup
    @user = users(:gai)
    @watchlist = @user.watchlists.build(name: "watchlist1") #=> example: { name: "watchlist1", user_id: 1 }
  end

  test "should be valid" do
    assert(@watchlist.valid?)
  end

  test "watchlist name should be present" do
    @watchlist.name = "   "  # this should be invalid
    assert_not(@watchlist.valid?)  # test pass if @watchlist.valid? is false, fail if true
  end

  test "name should have 25 characters or less" do
    @watchlist.name = "a" * 26  # invalid since it's greater than 25 characters
    assert_not(@watchlist.valid?)
  end

  test "user id should be present in row" do
    @watchlist.user_id = nil  # not valid
    assert_not(@watchlist.valid?)
  end
end
