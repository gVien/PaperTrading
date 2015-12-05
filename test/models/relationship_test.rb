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
    second_user = users(:second_user)
    assert_not gai.following?(second_user) # initially, verify gai is not following second user
    gai.follow(second_user)  #now gai follows second_user
    assert gai.following?(second_user)  # verify gai is following second user
    gai.unfollow(second_user)  #gai unfollow second_user
    assert_not gai.following?(second_user) #verify gai is not following second user
  end
end
