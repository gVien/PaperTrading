require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:gai)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Activate your PaperTrading account", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["no-reply@papertrading.com"], mail.from  # defined in ../mailers/application_mail.rb

    # regular expression can also be used in assert_match, e.g. assert_match /\w+/, 'foobar' (returns true)
    # or string such as assert_match 'baz', 'foobar' (# false)
    assert_match user.first_name.capitalize, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded # CGI::escape(user.email) is the g@example.com encoded to g%40example.com
  end

  test "password_reset" do
    mail = UserMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["no-reply@papertrading.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
