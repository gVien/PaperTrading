class UsersController < ApplicationController
  # verify a user is logged_in before these actions can be done
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :followers, :following]

  # verify a logged in user is the correct user
  before_action :correct_user, only: [:edit, :update]

  # verify the user is admin before destroy action can be done
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @post = current_user.posts.build if current_user# for form
    @posts = @user.posts.paginate(page: params[:page])
    # user cannot view another user's profile unless it's not expired or it's activated
    # `and` and `&&` are nearly identical but `&&` takes precedence over `and` and binds too tightly to root_url
    redirect_to root_url and return unless @user.activation_email_sent_at_not_expired? || @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      @user.send_activation_email
      flash[:success] = "You have successfully signed up! You are temporarily logged in. An activation email has been sent to your email. Please activate your account to prevent any disruption."
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "You have successfully updated your user profile!"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "#{full_name(user).titleize} is successfully deleted from the database."
    redirect_to users_url
  end

  # users/1/following => display list of people following the user
  def following
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    @title = "Following"
    render "show_follow"
  end

  # users/1/followers => display lists of user's followers
  def followers
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    @title = "Followers"
    render "show_follow"
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    # before filter (#before_action)

    # check if the user is the correct user
    # prevents one logged in user from modifying another's logged in user's info
    def correct_user
      user = User.find(params[:id])
      redirect_to root_url unless current_user?(user)
    end

    # check if the user is an admin, otherwise redirect to root
    # ensure that only the admin user is allowed to delete the user
    def admin_user
      redirect_to root_url unless current_user.admin?   # if not admin
    end
end
