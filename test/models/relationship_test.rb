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
end
