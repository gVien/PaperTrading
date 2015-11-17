require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @gai_admin = users(:gai)
    @non_admin_user = users(:second_user)
    @third_user = users(:third_user)
  end

  # tests the pagination page
  # 1. login in as an admin user
  # 2. get the user index page
  # 3. verify the index template renders properly
  # 4. verify the div pagination is on the page
  # 5. verify the link of each pagination works and each text is equal to the user full name
  # 6. verify that the delete link exists
  # 7. verify that the user count is 1 less (-1) after deleting a user

  # users#index page should only show activated users & user#show only for activated or account not expired after signup
  # 8. update attribute of activated for @third_user to false
  # 9. redirect to the users path
  # 10. Verify that the name of the inactivated user is not shown in the body of html
  # 11. get @third_user path
  # 12. verify the site redirects to root path
  test "index including pagination and presents of delete text" do
    log_in_as(@gai_admin)
    get users_path
    assert_template("users/index")
    assert_select "div.pagination"
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: full_name(user)
      # admin user cannot see the delete button next to his or her name
      assert_select("a[href=?]", user_path(user), text: "delete") unless user.admin? # if user is not admin
    end
    assert_difference "User.count", -1 do
      delete user_path(@non_admin_user)
    end

    # verify the inactivated is not shown in users#index
    # note the activation_email_sent_at time must be expired for @third_user in users.yml fixture for this test to pass
    @third_user.update_attribute(:activated, false) #8
    get users_path    # 9
    assert_no_match(/(Third User)/i, response.body) #10

    # show action test
    get user_path(@third_user) #11
    assert_redirected_to root_url #12
  end

  # 1. log in as non admin
  # 2. get the users path
  # 3. verify the non-admin user cannot see the delete anchor link

  # users#index page should only show activated users & user#show only for activated or account not expired after signup
  # 8. update attribute of activated for @third_user to false
  # 9. redirect to the users path
  # 10. Verify that the name of the inactivted user is not shown in the body of html
  # 11. get @third_user path
  # 12. verify the site redirects to root path
  test "non-admin user should not see delete links next to users name" do
    log_in_as(@non_admin_user)
    get users_path
    assert_select "a", text: "delete", count: 0

    # verify the inactivated is not shown in users#index
    # note the activation_email_sent_at time must be expired for @third_user in users.yml fixture for this test to pass
    @third_user.update_attribute(:activated, false) #8
    get users_path    # 9
    assert_no_match(/(Third User)/i, response.body) #10

    # show action test
    get user_path(@third_user) #11
    assert_redirected_to root_url #12
  end
end
