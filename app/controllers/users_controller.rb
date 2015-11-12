class UsersController < ApplicationController
  # verify a user is logged_in before these actions can be done
  before_action :logged_in_user, only: [:edit, :update]

  # verify a logged in user is the correct user
  before_action :correct_user, only: [:edit, :update]

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = "You have successfully logged in"
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

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    # before filter (#before_action)

    # check if a user is logged in, otherwise redirect to login url
    # prevents an unauthorized non-loggedin person from attempting to modify another's user's info
    def logged_in_user
      unless logged_in? #if user is not logged in
        store_location  #friendly forwarding
        flash[:danger] = "The action you requested is not valid. You may want to login."
        redirect_to login_url
      end
    end

    # check if the user is the correct user
    # prevents one logged in user from modifying another's logged in user's info
    def correct_user
      user = User.find(params[:id])
      redirect_to root_url unless current_user?(user)
    end
end
