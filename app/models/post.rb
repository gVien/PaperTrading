class Post < ActiveRecord::Base
  belongs_to :user
  # -> is “stabby lambda” syntax for an object called a Proc (procedure) or lambda
  default_scope -> { order(created_at: :desc) } # redefine the default order of posts

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
end
