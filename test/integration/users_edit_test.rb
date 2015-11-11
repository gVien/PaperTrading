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
    assert_tempate("users/edit")
  end
end
