class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)  #session from new.html.erb

    if @user && @user.authenticate(params[:session][:password])
      if @user.activated? # if account is activated, login
        login_and_redirect_with_remember(@user)
      elsif @user.activation_email_sent_at_not_expired? # elsif expiration time needed is valid, login
        login_and_redirect_with_remember(@user)
      else
        flash[:warning] = "Account not activated. Check your email for the activation link."
        redirect_to root_url
      end
    else
      # create an error message and render log in page
      # flash does not work like the one in the user controller since the render method does not count as a request
      # the flash message persists two request longer than we want
      # must use .now[:danger] to correct this minor bug
      flash.now[:danger] = "Invalid email/password combination. Please try again."
      render "new"
    end
  end

  def destroy
    # add condition to prevent an error when a user logs out in 1 tab, and tries to do it again /w another tab
    # (browser that supports multiple tabs)
    log_out if logged_in?
    redirect_to root_path
  end
end
