require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(followed_id: 1, follower_id: 2)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should have followed_id" do
    @relationship.followed_id = ""
    assert_not @relationship.valid?  #pass if valid? returns false
  end

  test "should have follower_id" do
    @relationship.follower_id = ""
    assert_not @relationship.valid?  #pass if valid? returns false
  end

  test "user can follow and unfollow another user" do
    gai = users(:gai)
    third_user = users(:third_user)
    assert_not gai.following?(third_user) # initially, verify gai is not following second user
    gai.follow(third_user)  #now gai follows third_user
    assert gai.following?(third_user)  # verify gai is following second user
    assert third_user.followers.include?(gai) # verify that the followers database for third_user includes gai
    gai.unfollow(third_user)  #gai unfollow third_user
    assert_not gai.following?(third_user) #verify gai is not following second user
  end
end
