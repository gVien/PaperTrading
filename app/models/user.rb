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
  def authenticated?(remember_token)
    # remember_token is not the same as the accessor (this is a reference, in case there is a confusion in the future)

    # multiple browsers, prevents an error when a second browser attempts to log out when the other browser already did
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)  # note this is the same as BCrypt::Password.new(remember_digest) == remember_token but it is clearer
  end

  # method to forget a user
  def forget
    update_attribute(:remember_digest, nil)
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
