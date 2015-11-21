class Post < ActiveRecord::Base
  belongs_to :user
  # -> is “stabby lambda” syntax for an object called a Proc (procedure) or lambda
  # equivalent to default_scope lambda { order(created_at: :desc) }
  default_scope -> { order(created_at: :desc) } # redefine the default order of posts
  mount_uploader :picture, PictureUploader # mount the migrated picture column to carrierwave PictureUploader

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
end
