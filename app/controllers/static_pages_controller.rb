class StaticPagesController < ApplicationController
  def home
    @market_summary = market_summary
    @market_trend = market_trend
    @ny_times = NewYorkTime.get_business_news.first(10)
  end

  def about
  end

  def contact
  end
end
