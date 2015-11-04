class Watchlist < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true, length: { maximum: 25 }
  validates :user_id, presence: true
end
