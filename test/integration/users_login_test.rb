require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

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

end
