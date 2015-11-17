class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include StaticPagesHelper
  include SessionsHelper
  include UsersHelper

  before_action :activate_account_required

  private
    def activate_account_required
      if current_user
        if logged_in? && current_user.activation_email_sent_at_not_expired? && !current_user.activated?
          time_left_to_logout = 60 - (Time.now - current_user.activation_email_sent_at)/60  # in minutes
          flash.now[:danger] = "Please check your email for a link to activate your account. Your session ends in #{time_left_to_logout.round(2)} minutes if you don't activate your account."
        elsif !current_user.activated?
          log_out
          flash[:danger] = "You are logged out! Please check your email for a link to activate your PaperTrading account!"
          redirect_to root_url
        end
      end
    end
end
