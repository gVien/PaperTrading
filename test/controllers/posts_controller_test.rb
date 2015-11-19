require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    @post = posts(:newest_post)
  end

  test "should redirect create if user is not logged in" do
    assert_no_difference "Post.count" do
      post(:create, post: { content: "This cannot be created"})
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy if user is not logged in" do
    assert_no_difference "Post.count" do
      delete(:destroy, id: @post)
    end
    assert_redirected_to login_url
  end
end
