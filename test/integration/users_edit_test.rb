require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @gai = users(:gai)
  end

  # unsuccessful edit test flow
  # 1. login as @gai
  # 2. get user edit page for @gai
  # 3. verify the edit template loads properly
  # 4. make a patch request to update user
  # 5. verify the edit template loads again (edit unsuccessfully)
  test "edit user unsuccessfully" do
    log_in_as(@gai)
    get edit_user_path(@gai)
    assert_template("users/edit")
    patch user_path(@gai), user: { first_name: "new",
                                   last_name:  "name",
                                   email: "invalidemail@",
                                   password: "123",
                                   password_confirmation: "456" }
    assert_template("users/edit")
  end

  # successful edit test flow
  # 1. login as user as @gai
  # 2. get user edit page
  # 3. make a patch request to update user with correct info
  # 4. verify there are no error flash messages
  # 5. verify the user is redirected to the profile page
  # 6. reload the the user's info in the database
  # 7. verify the user's full name and email in the database w/ the new ones
  test "edit user successfully" do
    log_in_as(@gai)
    get edit_user_path(@gai)
    new_first_name = "New"
    new_last_name = "Name"
    new_email = "gggg@test.com"
    patch user_path(@gai), user: { first_name: new_first_name,
                                   last_name:  new_last_name,
                                   email: new_email,
                                   password: "qwerty",
                                   password_confirmation: "qwerty" }
    assert_not(flash.empty?)
    assert_redirected_to user_path(@gai)
    @gai.reload # reload the user's info after the update
    assert_equal(full_name(@gai), "#{new_first_name} #{new_last_name}")
    assert_equal(@gai.email, new_email)
  end
end
