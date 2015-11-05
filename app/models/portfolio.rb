class Portfolio < ActiveRecord::Base
  belongs_to :user
  before_save :upcase_symbol

  validates :company_name, :quantity, :average_price, :user_id, presence: true
  validates :symbol, presence: true, uniqueness: { case_sensitive: false }

  private
    def upcase_symbol
      self.symbol = symbol.upcase
    end
end
