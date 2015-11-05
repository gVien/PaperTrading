require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:gai)
    @micropost = @user.microposts.build(content: "Hello") #=> example: { content: "Hello", user_id: 1 }
  end

  test "should be valid" do
    assert(@micropost.valid?)
  end

  test "micropost content should be present" do
    @micropost.content = "   "  # this should be invalid
    assert_not(@micropost.valid?)  # test pass if @micropost.valid? is false, fail if true
  end

  test "content should have 140 characters or less" do
    @micropost.content = "a" * 141  # invalid since it's greater than 140 characters
    assert_not(@micropost.valid?)
  end

  test "user id should be present in row" do
    @micropost.user_id = nil  # not valid
    assert_not(@micropost.valid?)
  end
end
