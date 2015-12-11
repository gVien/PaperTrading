class StaticPagesController < ApplicationController
  def home
    @market_summary = market_summary
    @market_trend = market_trend
    @ny_times = NewYorkTime.get_business_news.first(10)
    if logged_in?
      @post = current_user.posts.build  # for form
      # return all status feed for the current user + pagination
      @status_feed = current_user.feed.paginate(page: params[:page])
    end
  end

  def about
  end

  def contact
  end
end
