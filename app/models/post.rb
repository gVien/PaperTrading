class Post < ActiveRecord::Base
  belongs_to :user
  # -> is “stabby lambda” syntax for an object called a Proc (procedure) or lambda
  # equivalent to default_scope lambda { order(created_at: :desc) }
  default_scope -> { order(created_at: :desc) } # redefine the default order of posts
  mount_uploader :picture, PictureUploader # mount the migrated picture column to carrierwave PictureUploader

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validate :cap_picture_size

  private
    # server side validation for picture size (need client side too)
    def cap_picture_size
      if self.picture.size > 5.megabytes  #self is optional
        errors.add("Image size must be 5MB or less.")
      end
    end
end
