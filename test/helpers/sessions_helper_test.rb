require "test_helper"

class SessionsHelperTest < ActionView::TestCase
  # test the elsif branch of the current_user method in sessions_helper.rb
  # def current_user
  #   # modified current_user to incorporate remember_me feature
  #   # 1. if session[:user_id] exists, assign to @current_user
  #   if (user_id = session[:user_id])
  #     @current_user ||= User.find_by(id: user_id)
  #   elsif (user_id = cookies.signed[:user_id]) # 2. if not above, look for the cookies[:user_id] from the browser
  #     # find the user_id stored in the cookies in the database
  #     user = User.find_by(id: user_id)
  #     if user && user.authenticated?(cookies[:remember_token])
  #       log_in(user)
  #       @current_user = user
  #     end
  #   end
  # end

  def setup
    @gai = users(:gai)
    remember(@gai) # the elsif in the current_user method
  end

  # test the current_user
  # 1. verify the current_user is @gai user
  # 2. verify the user is logged in
  test "current_user returns the correct user when the session is nil (when cookies is detected)" do
    assert_equal(@gai, current_user)
    assert(user_logged_in?)
  end

  # test the current_user when the remember_token is not correct (this tests the authenticated? expression)
  # 1. update the remember_digest in the database
  # 2. verify the current_user is nil
  test "current_user returns nil when the remember_digest does not match" do
    @gai.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_equal(current_user, nil) # or assert_nil(current_user)
  end
end