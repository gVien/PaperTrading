class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  # def new
  # end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Your status has been successfully created!"
      redirect_to root_url
    else
      # this belongs to `static_pages/home` but Rails thinks it should be in `posts/`, will refactor
      @market_summary = market_summary
      @market_trend = market_trend
      @ny_times = NewYorkTime.get_business_news.first(10)
      render "static_pages/home"
    end
  end

  def destroy
  end

  private
    def post_params
      params.require(:post).permit(:content)
    end
end
