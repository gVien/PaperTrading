require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "first", last_name: "last", email: "first.last@example.com", password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert(@user.valid?, "User should be valid")
  end

  test "first name should be invalid" do
    # blank name is considered not present in model
    @user.first_name = "   "
    # pass if @user.valid? is false, fail if true
    assert_not(@user.valid?)
  end

  test "last name should be invalid" do
    @user.last_name = "     "
    assert_not(@user.valid?)  #pass if @user.valid? is false, which should be since blank is not present
  end

  test "email should be present" do
    @user.email = " "
    # pass if @user.valid? is false, fail if true
    assert_not(@user.valid?)
  end

  test "first name should not be more than 50 characters" do
    @user.first_name = "z" * 51
    # @user.valid returns true if the model does not restrict to less than or equal to 50 characters. The assert_not expects a false or nil value
    assert_not(@user.valid?, "Name should not be longer than 50 characters")
  end

  test "last name should not be more than 50 characters" do
    @user.last_name = "last" * 15
    assert_not(@user.valid?)
  end

  test "email should not be more than 255 characters" do
    @user.email = "z" * 244 + "@example.com"
    assert_not(@user.valid?, "Email should not be longer than 255 characters")
  end

  test "email validation should accept valid addresses format" do
    valid_addresses = %w[user@example.com USER@example2.com E_w-Q@one.two.edu first.last@company.tw hello+there@b.ru]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      # returns true if @user.valid is true
      # if false and returns the message per the element
      assert(@user.valid?, "#{valid_address.inspect} should be valid format")
    end
  end

  test "email validation should reject invalid addresses format" do
    invalid_addresses = %w[comma@example,com notproper_format.org no.domain@invalid.
                           underscore@under_score.com plussign@plus+sign.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      # pass if @user.valid is false, fail if true
      # add regexp in model solves this, since all these emails are not valid (returns false)
      assert_not(@user.valid?, "#{invalid_address.inspect} email is invalid")
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not(duplicate_user.valid?, "#{duplicate_user.email} exists in the system, please pick another email.")
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "mIxEd@CaSe.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal(mixed_case_email.downcase, @user.reload.email)
  end

  test "password should be present (cannot be blank)" do
    @user.password = @user.password_confirmation = " " * 6
    # pass if false, fail if true and then it will display the message
    assert_not(@user.valid?, "Password should be present (non-blank)")
  end

  test "password should have a minimum length of 6" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not(@user.valid?, "password must be at least 6 characters long")
  end

  # test replicates a scenario when a user uses two browsers to login to the site
  # when user logs out from one browser but not the others, which will create an error
  # since the remember_digest is nil in the database
  test "authenticated? should return false if remember_token is nil" do
    assert_not(@user.authenticated?(:remember_digest, "")) #expect authenticated?(:remember_digest, "") to return false to pass
  end

  test "all posts made by a user should be destroyed when a user is deleted" do
    @user.save
    @user.posts.create(content: "this will get deleted if a user is deleted")
    assert_difference "Post.count", -1 do
      @user.destroy
    end
  end
end
