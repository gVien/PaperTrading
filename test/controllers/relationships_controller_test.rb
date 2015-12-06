require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase

  # only login user can follow and unfollow another user
  # verify the relationship count does not change if it is created or destroyed if the user is not login
  # verify the user is redirected to the login page
  test "should require login in order to follow another user" do
    assert_no_difference "Relationship.count" do
      post :create
    end
    assert_redirected_to login_url
  end

  test "should require login in order to unfollow a followed user" do
    assert_no_difference "Relationship.count" do
      delete(:destroy, id: relationships(:follow1))
    end
    assert_redirected_to login_url
  end
end
