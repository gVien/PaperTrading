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

  # user must be logged in to update the user profile, otherwise redirect to home page (or other page)
  test "should redirect login page when attempting to update if not logged in" do
    patch :update, id: @gai, user: { first_name: @gai.first_name, last_name: @gai.last_name }
    assert_not(flash.empty?)  #pass if false
    assert_redirected_to login_url
  end
end
