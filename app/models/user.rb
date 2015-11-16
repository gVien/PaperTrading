class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  # make email to be down case and uniform before saving in database
  before_save :downcase_email
  before_create :create_activation_digest # generate a digest for the user before a user is created
  has_many :microposts
  has_many :watchlists
  has_many :portfolios
  has_many :trades

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, :presence => true, :length => { maximum: 255 }, :format => { with: VALID_EMAIL_REGEX }, :uniqueness => { case_sensitive: false }
  has_secure_password
  # allow_nil allows the user to edit the user w/o touching the password,
  # has_secure_password has a separate validation for nil password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def self.digest(string)
    # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
    # source from the above link
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    # string is the string that needs to be hash and cost is the computational cost to calculate the hash. The higher the cost, it will be harder to determine the original password
    BCrypt::Password.create(string, cost: cost)
  end

  # returns a random base 64 token (random combination of A–Z, a–z, 0–9, “-”, and “_”)
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # this method remembers a user in the database for use in persistent sessions (cookie)
  def remember
    # self refers to instance of User class since `remember` is not a class method
    self.remember_token = User.new_token  # similar to `password` virtual attribute used in has_secure_password
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # returns true if the given token (e.g. remember_token) matches the digest
  # this is similar to authenticate method from BCrypt, which compares password and password_digest
  def authenticated?(digest, token)
    # send method: lets us call a method with a name of our choice by “sending a message” to a given object
    # example below gives us an activation_digest from the database:
    # user = User.first
    # user.activation_digest => "$2a$10$ZYalH8a6JFgAPwM52uksUeYsExAOLHv/cfPvICoEia6/R9DDrKEEm"
    # user.send(:activation_digest) or user.send("activation_digest") => "$2a$10$ZYalH8a6JFgAPwM52uksUeYsExAOLHv/cfPvICoEia6/R9DDrKEEm"

    # Digest is the (Bcrypted hash) digest
    # use these parameters in symbol: remember_digest, activation_digest, password_digest, etc.
    digest = send("#{digest}")

    # for remember_digest which is created after the user is created
    # for multiple browsers with this app opened, prevents an error when a second browser attempts
    # to log out when the other browser already did
    return false if digest.nil?

    # this is the same as BCrypt::Password.new(digest) == token but cleaner
    BCrypt::Password.new(digest).is_password?(token)
  end

  # method to forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # returns true if the activation_email_sent_at time is within the expiration limit
  # use will be temporily logged in within the expiration limit after sign up
  def activation_email_sent_at_not_expired?
    !(self.activation_email_sent_at < 60.minutes.ago)
  end

  # send activation link via email after sign up and update email sent time
  def send_activation_email
    # self is the user object
    UserMailer.account_activation(self).deliver_now
    self.update_attribute(:activation_email_sent_at, Time.zone.now)
  end

  # activates the account
  def activate_account
    self.update_columns(activated: true, activated_at: Time.zone.now)
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    # this creates the activation token and digest for account activation
    # a newly signed up user will have activation token and digest assigned to each user object
    def create_activation_digest
      # note self refers to the instance of User class while User refers to the class method
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
