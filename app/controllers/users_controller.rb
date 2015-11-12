class UsersController < ApplicationController
  # verify a user is logged_in before these actions can be done
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  # verify a logged in user is the correct user
  before_action :correct_user, only: [:edit, :update]

  # verify the user is admin before destroy action can be done
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(:page => params[:page])
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

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "#{full_name(user).titleize} is successfully deleted from the database."
    redirect_to users_url
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

    # check if the user is an admin, otherwise redirect to root
    # ensure that only the admin user is allowed to delete the user
    def admin_user
      redirect_to root_url unless current_user.admin?   # if not admin
    end
end
