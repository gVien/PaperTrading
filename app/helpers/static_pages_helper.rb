module StaticPagesHelper
  # quote summary of the market
  def market_summary
    TradeKing.get_quote("DJI,SPX,COMP").reverse
  end

  def market_trend
    {
      "Top Active": TradeKing.get_topactive.first(10),
      "Top Volume": TradeKing.get_topvolume.first(10),
      "Top $ Losers": TradeKing.get_toplosers.first(10),
      "Top $ Gainers": TradeKing.get_topgainers.first(10),
      "Top % Losers": TradeKing.get_top_pct_losers.first(10),
      "Top % Gainers": TradeKing.get_top_pct_gainers.first(10)
    }
  end

  # def market_trend_volume
  #   {
  #     "Top Active": TradeKing.get_topactive,
  #     "Top Volume": TradeKing.get_topvolume
  #   }
  # end
end
