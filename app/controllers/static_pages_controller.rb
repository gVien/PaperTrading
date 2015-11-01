class StaticPagesController < ApplicationController
  def home
    @test = TradeKing.get_quote("BABA")
  end

  def about
  end
end
