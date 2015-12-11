require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:gai)
    @third_user = users(:third_user)  # third user has not been followed by @user in relationships fixture
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

  # follow/unfollow without Ajax

  test "should follow the user via html (no js or js is disabled)" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, followed_id: @third_user.id
    end
  end

  # follow another user
  # define the relationship
  # verify the count is 1 less
  test "should unfollow the user via html (no js or js is disabled)" do
    @user.follow(@third_user)
    relationship = @user.active_relationships.find_by(followed_id: @third_user.id)
    assert_difference '@user.following.count', -1 do
      delete(relationship_path(relationship))
    end
  end

  # follow/unfollow with Ajax

  test "should follow the user via Ajax call" do
    assert_difference "@user.following.count", 1 do
      xhr(:post, relationships_path, followed_id: @third_user.id)
    end
  end

  test "should unfollow the user via Ajax call" do
    @user.follow(@third_user)
    relationship = @user.active_relationships.find_by(followed_id: @third_user.id)
    assert_difference '@user.following.count', -1 do
      xhr(:delete, relationship_path(relationship))
    end
  end

  test "home should have status feed for current user and following users" do
    get(root_path)
    @user.feed.paginate(page: 1).each do |post|
      # <%# CGI.unescapeHTML to decode and CGI.escapeHTML to encode (e.g. ' => &#8217;) %>
      assert_match CGI.escapeHTML(post.content), response.body
    end
  end
end
