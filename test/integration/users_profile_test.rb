require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:gai)
  end

  # visit the user profile page
  # check for page title, user's name, Gravatar, post count, and paginated posts.
  test "profile page should have contents" do
    log_in_as(@user)
    get(user_path(@user))
    assert_template("users/show")
    # check if page's title is equal to the full title
    assert_select "title", full_title(full_name(@user))
    assert_select "h1", text: full_name(@user)
    assert_select "h1>img.gravatar" #checks for img tag /w gravatar class
    assert_match @user.posts.count.to_s, response.body #check if the count matches with the number inside body (includes all of html, not just body)
    posts_paginate_1 = @user.posts.paginate(page: 1)
    # check if each post has content
    posts_paginate_1.each do |post|
      assert_match post.content, response.body
    end
  end
end
