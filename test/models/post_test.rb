require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:gai)
    @post = @user.posts.build(content: "Hello") #=> example: { content: "Hello", user_id: 1 }
  end

  test "should be valid" do
    assert(@post.valid?)
  end

  test "post content should be present" do
    @post.content = "   "  # this should be invalid
    assert_not(@post.valid?)  # test pass if @post.valid? is false, fail if true
  end

  test "content should have 140 characters or less" do
    @post.content = "a" * 141  # invalid since it's greater than 140 characters
    assert_not(@post.valid?)
  end

  test "user id should be present in row" do
    @post.user_id = nil  # not valid
    assert_not(@post.valid?)
  end

  test "order of posts should be at the most recent first" do
    # default order of posts is ASC (oldest to newest)
    # redefine the posts model to reverse the order to DESC => `default_scope -> { order("created_at DESC") }`
    assert_equal(posts(:newest_post), Post.first)
  end
end
