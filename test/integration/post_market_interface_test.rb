require 'test_helper'

class PostMarketInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:gai)
    @second_user = users(:second_user)
  end

  # 1. login as user
  # 2. get home page
  # 3. verify there is pagination
  # 4. user posts an invalid post
  # 5. verify the user cannot post an invalid post (no differnece in count)
  # 6. verify the error message pops up
  # 7. user posts a valid post
  # 8. verify the user can post a valid post (difference in count of 1)
  # 9. verify the link is redirected to root url after a post
  # 10. verify the post made earlier is on the home page
  # 11. verify there is delete link
  # 12. verify the user can delete its own post
  # 13. get home page of another user
  # 14. verify the user cannot delete another's user post
  test "the interface of posts" do
    log_in_as(@user)  #1
    get(root_path)  #2
    assert_select("div.pagination")  #3
    assert_no_difference "Post.count" do  #4, 5
      post(posts_path, post: { content: ""})
    end
    assert_select("div#error_explanation")  #6

    assert_difference "Post.count", 1 do  #7, 8
      post(posts_path, post: { content: "valid post"})
    end
    assert_redirected_to root_url  #9
    follow_redirect!
    assert_match "valid post", response.body  #10

    assert_select "a", text: "delete"  #11
    assert_difference "Post.count", -1 do  #12
      delete(post_path(@user.posts.paginate(page: 1).first))
    end

    get user_path(@second_user)  #13
    assert_select "a", text: "delete", count: 0 # 14
  end
end
