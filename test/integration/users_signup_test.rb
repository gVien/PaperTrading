require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    # clears all deliveries in case if some other test deliver email
    ActionMailer::Base.deliveries.clear   # mail delivery is stored in an array
  end

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
  test "valid signup info w/ temporary logged in and account activation" do
    get signup_path
    # works similar to assert_no_difference
    # but in this case, we want to see a differene of 1 (that parameter is optional)
    assert_difference "User.count", 1 do
      # post_via_redirect is used to redirect after post, resulting in rendering of "users/show" template
      post users_path, user: { first_name: "Gai",
        last_name: "user",
        email: "gai@correctemail.org",
        password: "123456",
        password_confirmation: "123456"}
    end
    # the test follows the routine after sign up
    # 1. verify the email is sent out (check size of 1)
    # 2. use assign method to access the @user in create action of user ctrler (which is the user created above)
    # 3. verify the account is not activated.
    # 4. verify the user is temporily logged in
    # 4.1 verify several pages of the websites have warning flash
    # 5. patch the user and update the activation_email_sent_at to passed expiration date
    # 5.1 get users_path (or any other path)
    # 5.2 redirect webpage
    # 6. verify the user is no longer logged in after activation_email_sent_at passed expiration date
    # 7. user attempts to log in
    # 7.1 verify the user cannot log in

    # 8. get the invalid activation token link
    # 9. verify the user is not logged in since it's not activated from the wrong activation link
    # 10. get correct activation token link w/ wrong email
    # 11. verify the user is not logged in
    # 12. get correct activation token link w/ correct email
    # 13. verify user is logged in
    # 14. redirect
    # all other tests shall be the same
    assert_equal 1, ActionMailer::Base.deliveries.size  #check size of email
    user = assigns(:user)
    assert_not user.activated?
    assert user_logged_in?  # 4

    # 4.1 verify several pages of the websites have warning flash
    get users_path
    assert_not(flash.empty?)
    get root_path
    assert_not(flash.empty?)
    get edit_user_path(user)
    assert_not(flash.empty?)

    #expiration limit is an hour after activation email sent out
    user.activation_email_sent_at = 2.hours.ago  # some reason `patch :update` doesn't work
    user.save

    #5.1, 5.2, 6
    get users_path
    follow_redirect!
    assert_not user_logged_in?

    # 7. user attempts to login
    log_in_as(user)
    assert_not user_logged_in?

    # test 9-14
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not user_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong_email')
    assert_not user_logged_in?
    # Valid activation token, right email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!

    assert_template "users/show"
    assert user_logged_in? # confirm user is login after activation
    assert_not(flash.empty?)
  end
end
