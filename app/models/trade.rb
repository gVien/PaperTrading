class Trade < ActiveRecord::Base
  belongs_to :user
  before_save :upcase_symbol_traded

  validates :symbol_traded, :shares_traded, :total_amount_traded, :user_id, presence: true

  private
    def upcase_symbol_traded
      self.symbol_traded = symbol_traded.upcase
    end
end
