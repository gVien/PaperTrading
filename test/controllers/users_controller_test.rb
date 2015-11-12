require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @gai = users(:gai)
    @new_user = users(:second_user)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # user must be logged in to edit the user profile, otherwise redirect to login page
  test "should redirect login page when attempting to edit if not logged in" do
    # get edit_user_path(@gai)
    get :edit, id: @gai #access the edit link of a user
    assert_not(flash.empty?)  #pass if false
    assert_redirected_to login_url
  end

  # user must be logged in to update the user profile, otherwise redirect to login page
  test "should redirect login page when attempting to update if not logged in" do
    patch :update, id: @gai, user: { first_name: @gai.first_name, last_name: @gai.last_name }
    assert_not(flash.empty?)  #pass if false
    assert_redirected_to login_url
  end

  # a user logged in cannot edit/update another's user profile page, and should redirect to root page
  # 1. log in as @gai
  # 2. attempt to edit/update @new_user setting
  # 3. verify flash is empty since a user cannot edit/update another's user info, so it won't render edit
  # 4. verify a redirect to the root url
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@gai)
    get :edit, id: @new_user #access the edit link of a user
    assert(flash.empty?)
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@gai)
    patch :update, id: @new_user, user: { first_name: @new_user.first_name, last_name: @new_user.last_name }
    assert(flash.empty?)
    assert_redirected_to root_url
  end
end
