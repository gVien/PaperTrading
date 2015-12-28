class Stock < ActiveRecord::Base
  has_many :watchlists_stocks
  has_many :watchlists, through: :watchlists_stocks
  before_save :upcase_symbol

  default_scope -> { order(symbol: :ASC) } # redefine the default order of symbol

  validates :symbol, presence: true
  validates :company_name, presence: true

  def self.search(query)
    # if symbol exists, display the matched stock
    # elsif blank && lists of stock exists, display lists of stocks partially matching query unless it's empty
    # else return nil
    if stock = find_by(symbol: query)
      stock
    elsif !query.blank? && list_of_stocks = where('symbol LIKE ?', "%#{query}%") # query must not be blank!
      list_of_stocks unless list_of_stocks.blank?  #empty array should be filtered
    else # covers when query is nil + empty
      nil
    end
  end

  private
    def upcase_symbol
      self.symbol = symbol.upcase
    end
end
