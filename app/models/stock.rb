class Stock < ActiveRecord::Base
  has_many :watchlists_stocks
  has_many :watchlists, through: :watchlists_stocks
  before_save :upcase_symbol

  validates :symbol, presence: true
  validates :company_name, presence: true
  validates :watchlist_id, presence: true

  private
    def upcase_symbol
      self.symbol = symbol.upcase
    end
end
