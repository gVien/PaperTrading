require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # test criteria for invalid signup info
  # get the sign up path
  # verify user count in database is the same after making a post request to sign up with invalid info
  # verify users/new template is render
  # verify all errors message display (div#error_explanation, div li, div.field_with_errors)
  test "invalid sign up info" do
    get signup_path
    # long way
    # before_count = User.count
    # post users_path, user: { first_name:  "",
    #                          last_name: "",
    #                            email: "invalid_email_format",
    #                            password:              "123",
    #                            password_confirmation: "456" }
    # after_count  = User.count
    # assert_equal before_count, after_count
    # cleaner way
    assert_no_difference "User.count" do
      post users_path, user: { first_name:  "",
                               last_name: "",
                               email: "invalid_email_format",
                               password:              "123",
                               password_confirmation: "456" }
    end
    assert_template "users/new"
    assert_select("div#error_explanation")
    assert_select("div li")
    assert_select("div.field_with_errors")
  end

  # test criteria for valid sign up info
  # get signup path
  # verify user count is increased by 1 after making a post request w/ valid user sign up info
  # verify users/show template is render
  # verify the user is logged in after a successful sign up
  # verify success flash message is displayed that user successfully signup (e.g flash hash is empty)
  test "valid signup info" do
    get signup_path
    # works similar to assert_no_difference
    # but in this case, we want to see a differene of 1 (that parameter is optional)
    assert_difference "User.count", 1 do
      # post_via_redirect is used to redirect after post, resulting in rendering of "users/show" template
      post_via_redirect users_path, user: { first_name: "Gai",
        last_name: "user",
        email: "gai@correctemail.org",
        password: "123456",
        password_confirmation: "123456"}
    end
    assert_template "users/show"
    assert logged_in?
    assert_not(flash.empty?)  # pass if flash is empty (false) since we have success flash, otherwise fail (true)
  end
end
