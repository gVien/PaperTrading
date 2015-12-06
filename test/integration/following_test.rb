require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:gai)
    log_in_as(@user)
  end

  # test for following/follower page (not comprehensive since we want to make sure it's working)
  # 1. get following for the specific user
  # 2. verify the user following list is not empty
  # 3. verify "following" word is on the page
  # 4. verify following list count is in the body
  # 5. verify the link for each item in the following list is active
  test "following page" do
    get following_user_path(@user)  #1
    assert_not @user.following.empty?   #2
    assert_match "Following", response.body   #3
    assert_match @user.following.count.to_s, response.body  #4
    @user.following.each { |user| assert_select "a[href=?]", user_path(user)}   #5
  end

  # test for followers page
  test "follower page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match "Followers", response.body
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each { |user| assert_select "a[href=?]", user_path(user)}
  end
end
