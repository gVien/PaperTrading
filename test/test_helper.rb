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
end
