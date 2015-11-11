ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  # including the SessionsHelper gives some weird errors. The `logged_in?` does not work when using after `delete logout_path` request
  # this helper method works the same way as `logged_in?` in session helper but will be used in test
  def user_logged_in?
    !session[:user_id].nil?
  end

  # helper methodto log in as a user
  def log_in_as(user, options = {})
    # fetch returns the second parameter if no parameter is given
    password = options.fetch(:password, "123456") # default password must match with users.yml
    remember_me = options.fetch(:remember_me, "1")
    if integration_test?   # integration test only
      post login_path, session: { email: user.email,
                                  password: password,
                                  remember_me: remember_me}
    else  # all other test
      session[:user_id] = user.id
    end
  end

  private
    # returns true if test is inside the integration test (post_via_redirect is only available in integration test), false otherwise
    # note: defined method returns true if the argument is defined inside a specific test (i.e. integration test)
    def integration_test?
      defined?(post_via_redirect)
    end
end
