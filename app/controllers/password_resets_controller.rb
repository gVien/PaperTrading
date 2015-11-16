class PasswordResetsController < ApplicationController
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

  def edit
  end
end
