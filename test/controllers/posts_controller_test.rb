require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    @gai = users(:gai)
    @post = posts(:newest_post)  # post belong to @gai
    @second_user = users(:second_user)
    @food = posts(:food)  # post belong to @second_user
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

  # test flow
  # 1. login as @gai
  # 2. verify @second_user cannot delete @post made by @gai
  # 3. verify the page is redirected to root
  test "should redirect destroy if user is not the current user who made the post" do
    log_in_as(@gai)
    assert_no_difference("Post.count") do
      delete(:destroy, id: @food)
    end
    assert_redirected_to root_url # root_url defined in check_correct_user_post method
  end
end
