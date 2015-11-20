class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  before_action :check_correct_user_post, only: [:destroy]

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
      @status_feed = current_user.posts.paginate(page: params[:page])
      render "static_pages/home"
    end
  end

  def destroy
    @post.destroy # from check_correct_user_post method
    flash[:success] = "Your status has been deleted!"

    # request.referrer (which is HTTP_REFERER) is the previous URL
    # works similarly to friendly forwarding `request.url`
    redirect_to request.referrer || root_url
  end

  private
    def post_params
      params.require(:post).permit(:content)
    end

    # before filters

    def check_correct_user_post
      @post = current_user.posts.find_by(id: params[:id])  # find the post of the current_user
      redirect_to root_url if @post.nil?  # redirect to root_url if the post is not found
    end
end
