require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    @gai = users(:gai)
    ActionMailer::Base.deliveries.clear # clear email array
  end

  # the steps to reset password test
  # 1. visit the forgot password link
  # 2. verify the forgot password template renders properly

  # case 1: wrong email
  # 3. enter an email that is not valid (not in database) - post request
  # 4. verify email is not valid (flash is not empty)
  # 5. verify the forgot password template renders properly (again)

  # case 2: correct email
  # 6. enter an email that is valid - post request
  # 7. verify the reset digest before case #5 is not equal to after case #5
  # 8. verify the email delivery size is 1 more than before
  # 9. verify email is not valid (flash is not empty)
  # 10. verify the root url template renders properly (since if it's a valid email then it redirects to the root url)

  # checks email and click on link
  # 11. assign the user from the ctrler (reset ctrler?)

  # if user modify the form and put in wrong email, we need to make sure it's invalid
  # 12. get the form of password reset with wrong email in url link
  # 13. verify that it redirects to root url
  # 14. verify flash is not empty (optional since I added more features)

  # inactive user (activated attribute is false)
  # 15. toggle activated user & get the edit form with invalid email in link
  # 16. verify the site redirects to root url
  # 17. toggle activated user

  # correct email but wrong token
  # 18. get the edit form with the right email but wrong token in url link below
  # e.g. http://localhost:3000/password_resets/OjvqMyB1Q5A_F2gASDn9WQ/edit?email=thehell%40gmail.com
  # 19. verify the site redirects to root url

  # correct email, right token
  # 20. get the edit form with right email + right token in link
  # 21. verify the template for edit form renders properly
  # 22. verify the hidden email field input is present in the form

  # edit form test
  # invalid password and confirmation
  # 23. patch password reset with invalid password + password confirmation (e.g. too short or do not match) for user
  # 24. verify the div with "error explanation" class appears

  # empty password
  # 25. patch password reset with empty password + password confirmation for user
  # 26. verify the div with "error explanation" class appears

  # valid password + confirmation
  # 27. patch password reset with valid password + password confirmation for user
  # 28. verify the user is logged in
  # 29. verify the flash is not empty (since there is success message)
  # 30. verify the user is being redirected to the user profile page
  test "reset password" do
    get(new_password_reset_path)  # 1
    assert_template('password_resets/new')  # 2

    # case 1: wrong email
    post password_resets_path, password_reset: { email: "" } # 3
    assert_not(flash.empty?)   # 4
    assert_template('password_resets/new')  # 5

    # case 2: right email
    post password_resets_path, password_reset: { email: @gai.email } #6
    assert_not_equal @gai.reset_digest, @gai.reload.reset_digest  #7
    assert_equal 1, ActionMailer::Base.deliveries.size  #8
    assert_not flash.empty? #9
    assert_redirected_to(root_url) #10

    # email sent, testing the url to activate password

    # Password reset form
    user = assigns(:user) #11

    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "") #12
    assert_redirected_to(root_url)  #13
    assert_not flash.empty? #14

    # Inactive user
    user.toggle!(:activated)  #15
    get edit_password_reset_path(user.reset_token, email: user.email) #15
    assert_redirected_to(root_url)  #16
    user.toggle!(:activated) #17  # toggle activated from false to true and/or vice versa

    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email) #18
    assert_redirected_to(root_url)  #19

    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)   #20
    assert_template 'password_resets/edit'  #21
    assert_select "input[name=email][type=hidden][value=?]", user.email #22

    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "123456",
                  password_confirmation: "678901" } #23
    assert_select 'div#error_explanation' #24

    # Empty password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "",
                  password_confirmation: "" } #25
    assert_select 'div#error_explanation' #26

    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "123456",
                  password_confirmation: "123456" } #27
    assert user_logged_in?  #28
    assert_not flash.empty? #29
    assert_redirected_to user   #30
  end

  # test process
  # 1. get the new password reset form
  # 2. enter email address (post request)
  # 3. assign the users from ctrl
  # 4. update the assigned user attribute and have the password expired
  # 5. get the edit password/confirmation form for user
  # 6. verify the link is redirected to the new password reset form
  # 7 redirect to edit page
  # 8. verify the body contains "expired"
  test "should not reset password if reset token is expired" do
    get new_password_reset_path
    post password_resets_path, password_reset: { email: @gai.email }
    user = assigns(:user)
    user.update_attribute(:reset_sent_at, 5.hours.ago) # password reset sent 5 hours which expires 4 hours
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to new_password_reset_path
    follow_redirect!  # redirect the page to edit_password_reset_path
    assert_match /(Password reset link has expired)/i, response.body  # phase defined in password_reset controler
  end
end
