class Post < ActiveRecord::Base
  belongs_to :user
  # -> is “stabby lambda” syntax for an object called a Proc (procedure) or lambda
  # equivalent to default_scope lambda { order(created_at: :desc) }
  default_scope -> { order(created_at: :desc) } # redefine the default order of posts
  mount_uploader :picture, PictureUploader # mount the migrated picture column to carrierwave PictureUploader

  validates :content, length: { maximum: 140 }
  validates :user_id, presence: true
  validate :cap_picture_size, :allow_blank_content_if_picture_exists

  # parse url in content into links
  auto_html_for :content do
    html_escape
    image
    # For YouTube, default width is 420, height 315 if not specified
    # not setting will not affect the responsive of the video, since CSS will take care of it
    youtube(:width => 560, :height => 349, :autoplay => false)
    vimeo(:show_title => true, :allow_fullscreen => true) # see config/initializers/auto_html.rb for custom filter
    twitter
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  private
    # server side validation for picture size (need client side too)
    def cap_picture_size
      if self.picture.size > 5.megabytes  #self is optional
        errors.add(:picture, "Image size must be 5MB or less.")
      end
    end

    def allow_blank_content_if_picture_exists
      # if picture exists, then content is allowed to be blank
      if self.content.blank?
        errors.add(:content, "cannot be blank without picture.") unless self.picture?
      end
    end
end
