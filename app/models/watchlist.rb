class Watchlist < ActiveRecord::Base
  belongs_to :user
  has_many :stocks

  validates :name, presence: true, length: { maximum: 25 }
  validates :user_id, presence: true
end
