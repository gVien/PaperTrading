class User < ActiveRecord::Base
  # make email to be down case and uniform before saving in database
  before_save { self.email = email.downcase}
  has_many :microposts

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, :presence => true, :length => { maximum: 255 }, :format => { with: VALID_EMAIL_REGEX }, :uniqueness => { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def self.digest(string)
    # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
    # source from the above link
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    # string is the string that needs to be hash and cost is the computational cost to calculate the hash. The higher the cost, it will be harder to determine the original password
    BCrypt::Password.create(string, cost: cost)
  end
end
