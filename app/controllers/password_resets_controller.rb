class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]


  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Check your email for password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "We cannot recogniz that email in our database. Please try again with the correct email."
      render "new"
    end
  end

  # edit/update apply to these 4 cases
  # 1. a reset link is expired (edit/update)
  # 2. a reset is successful (update)
  # 3. a failed reset (invalid password) - applies to update
  # 4. a failed reset that seems successful initially (a blank password) - applies to update
  def edit
  end

  def update
  end

  private
    # find the user using email via hidden field
    def find_user
      @user = User.find_by(email: params[:email])
    end

    # confirm the user account is activated, exist, and authenticated w/ correct reset token
    def valid_user
       # /password_resets/:id/edit?email=encoded_email
       # /password_resets/0enrhAa0CyycHEUxJvCAiA/edit?email=example%40example.com
      unless @user.activated? && @user && @user.authenticated?(:reset_digest, params[:id])
        flash[:danger] = "Password reset is invalid."
        redirect_to root_url
      end
    end
end
