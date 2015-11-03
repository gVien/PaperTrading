module StaticPagesHelper
  # quote summary of the market
  def market_summary
    TradeKing.get_quote("DJI,SPX,COMP").reverse
  end

  def market_trend
    {
      "Top Active": TradeKing.get_topactive,
      "Top Volume": TradeKing.get_topvolume,
      "Top $ Losers": TradeKing.get_toplosers,
      "Top $ Gainers": TradeKing.get_topgainers,
      "Top % Losers": TradeKing.get_top_pct_losers,
      "Top % Gainers": TradeKing.get_top_pct_gainers
    }
  end

  # def market_trend_volume
  #   {
  #     "Top Active": TradeKing.get_topactive,
  #     "Top Volume": TradeKing.get_topvolume
  #   }
  # end
end
