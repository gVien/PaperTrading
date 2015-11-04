class Stock < ActiveRecord::Base
  belongs_to :watchlist
  before_save :upcase_symbol

  validates :symbol, presence: true
  validates :company_name, presence: true
  validates :watchlist_id, presence: true

  private
    def upcase_symbol
      self.symbol = symbol.upcase
    end
end
