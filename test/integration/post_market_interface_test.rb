require 'test_helper'

class PostMarketInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:gai)
    @second_user = users(:second_user)
  end

  # 1. login as user
  # 2. get home page
  # 3. verify there is pagination
  # 3.1 verify the post button is disabled when the form or file upload is not present

  # Part 1: user post an empty content without picture upload present
  # 4. user posts an invalid post
  # 5. verify the user cannot post an invalid post (empty) if picture upload is not present
  # 6. verify the error message pops up

  # Part 2: user post a nonempty content WITHOUT picture upload present
  # 7. user posts a valid post without picture present
  # 8. verify the user can post a valid post (difference in count of 1)
  # 9. verify the link is redirected to root url after a post
  # 10. verify the post made earlier is on the home page
  # 11. verify there is delete link

  # Part 3: user post an empty contentwith picture upload present
  # 12. define the picture to be uploaded
  # 13. verify the user can post an empty post if picture upload is present
  # 14. verify the link is redirected to root url after a post
  # 15. verify the content attribute is nil but picture is present (true)
  # 16. verify the image is on the home page
  # 17. verify the delete link

  # Part 4: user post an nonempty content WITH picture upload present
  # 18. define another picture to be uploaded
  # 19. verify the user can post a nonempty post WITH picture upload present
  # 20. assign the post just created with a variable
  # 21. verify the link is redirected to root url after a post
  # 22. verify the content and picture attributes are present (true)
  # 23. verify the post made earlier is on the home page
  # 24. verify the delete link

  # 25. verify the user can delete its own post
  # 26. get home page of another user
  # 27. verify the user cannot delete another's user post
  test "the interface of posts" do
    log_in_as(@user)  #1
    get(root_path)  #2
    assert_select("div.pagination")  #3

    # this is a light test to verify the `post` button is disabled
    # for a more interactive test, Capybara needs to be integrated with Minitest
    assert_select("form input[type=submit][disabled=disabled]") #3.1

    # Part 1: user post an empty post without picture upload present
    assert_no_difference "Post.count" do  #4, 5
      post(posts_path, post: { content: ""})
    end
    assert_select("div#error_explanation")  #6

    # Part 2: user post a nonempty content WITHOUT picture upload present
    assert_difference "Post.count", 1 do  #7, 8
      post(posts_path, post: { content: "valid post"})
    end
    assert_redirected_to root_url  #9
    follow_redirect!
    assert_match "valid post", response.body  #10
    assert_select "a", text: "delete"  #11

  # 17. verify the delete link
    # Part 3: user post an empty content with picture upload present
    # fixture_file_upload returns an UploadedFile object with attributes content_type, original_filename, and tempfile
    # for Windows OS, add in `:binary` => fixture_file_upload(file, type, :binary)
    pix1 = fixture_file_upload("test/fixtures/search-box.png", "image/png") #12
    assert_difference "Post.count", 1 do  #13
      post(posts_path, post: { content: "", picture: pix1 })
    end
    post1 = assigns(:post)
    assert_redirected_to root_url #14
    assert(post1.content.blank?) #15
    assert(post1.picture?)  #15
    follow_redirect!
    assert_select ".content img"   #16
    assert_select "a", text: "delete"  #17

    # Part 4: user post an nonempty post WITH picture upload present
    pix2 = fixture_file_upload("test/fixtures/search-box-2.png", "image/png") #18
    assert_difference "Post.count", 1 do  #19
      post(posts_path, post: { content: "post2", picture: pix2 })
    end
    post2 = assigns(:post)   #20
    assert_redirected_to root_url #21
    assert_equal(post2.content, "post2") #22
    assert(post2.picture?)  #22
    follow_redirect!
    assert_match post2.content, response.body  #23
    assert_select ".content img"   #23
    assert_select "a", text: "delete"  #24

    #
    assert_difference "Post.count", -1 do  #25
      delete(post_path(@user.posts.paginate(page: 1).first))
    end

    get user_path(@second_user)  #26
    assert_select "a", text: "delete", count: 0 # 27
  end

  # post a link, should be selectable with `a` tag
  # post a Youtube video, should be selectable w/ appripriate tag (.youtube iframe)
  # post a Vimeo video, should be selectable w/ appripriate tag (.vimeo iframe)
  # post a Twitter post, should be selectable w/ appripriate tag (iframe)
  test "conversion of urls into resources (link, youtube, vimeo, twitter, etc)" do
    log_in_as(@user)
    get(root_path)

    # links
    assert_difference "Post.count", 1 do
      post(posts_path, post: { content: "http://www.google.com" })
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match "#{@user.posts.first.content}", response.body
    assert_select "a[href=?]", @user.posts.first.content

    # Youtube Videos
    assert_difference "Post.count", 1 do
      post(posts_path, post: { content: 'https://www.youtube.com/watch?v=e1210RZl8i4&list=PL6485CF3A4C7EB225' })
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_select ".youtube iframe"

    # Vimeo Videos
    assert_difference "Post.count", 1 do
      post(posts_path, post: { content: 'https://vimeo.com/74008847' })
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_select ".vimeo iframe"

    # Twitter Shared Links
    assert_difference "Post.count", 1 do
      post(posts_path, post: { content: 'https://twitter.com/google/status/651460310037999616' })
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_select '.twitter-tweet'  # twitter wraps the resources inside the iframe
  end
end
