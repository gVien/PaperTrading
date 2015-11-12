require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @gai = users(:gai)
  end

  # tests the pagination page
  # 1. login in as a user
  # 2. get the user index page
  # 3. verify the index template renders properly
  # 4. verify the div pagination is on the page
  # 5. verify the link of each pagination works and each text is equal to the user full name
  test "index including pagination" do
    log_in_as(@gai)
    get users_path
    assert_template("users/index")
    assert_select "div.pagination"
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: full_name(user)
    end
  end
end
