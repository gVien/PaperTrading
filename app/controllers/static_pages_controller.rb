class StaticPagesController < ApplicationController
  def home
    @market_summary = market_summary
    @market_trend_pct = market_trend
  end

  def about
  end

  def contact
  end
end
