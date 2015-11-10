require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @gai = users(:gai)
  end

  # test process
  # 1. Visit the login path.
  # 2. Verify that the login/session form renders correctly.
  # 3. Post to the sessions path with an invalid email and password.
  # 4. Verify that the login/session form renders again and verify flash messages appear.
  # 5. Visit another page (such as the Home page).
  # 6. Verify that the flash message disappears on the new page.
  test "login with invalid information" do
    get login_path #1
    assert_template "sessions/new" #2
    post login_path, session: { email: "wrong", password: "login_info"}  #3
    assert_template "sessions/new"  #4
    assert_not flash.empty? # test only pass if flash.empty is false. # 4
    get root_path #get "/" #5
    assert flash.empty?  #6, must be empty in the new page
  end

  # login w/ valid info process
  # 1. visit login path
  # 2. post to the session path with valid email + password
  # 3. verify after login, it redirects to the user path (.../users/1)
  # 4. verify the sign up link disappears
  # 5. verify the login link disappears
  # 6. verify the home link appears
  # 7. verify the profile link appears
  # 8. verify the setting link appears (not active yet)
  # 9. verify the logout link appears
  test "login with valid information" do
    get login_path  #1
    post login_path, session: { email: @gai.email, password: "123456"}  #2
    assert_redirected_to @gai #3
    follow_redirect!  # visit target page
    assert_template "users/show"
    assert_select "a[href=?]", signup_path, count: 0  #4
    assert_select "a[href=?]", login_path, count: 0 #5
    assert_select "a[href=?]", root_path, count: 2 #6
    assert_select "a[href=?]", user_path(@gai)   #7
    # assert_select "a[href=?]", edit_user_path(@gai)   #8
    assert_select "a[href=?]", logout_path   #9
  end
end
