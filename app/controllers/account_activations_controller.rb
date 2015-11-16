class AccountActivationsController < ApplicationController

  # /account_activation/:id/edit?email=encoded_email
  # /account_activation/0enrhAa0CyycHEUxJvCAiA/edit?email=example%40example.com
  def edit
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:activation_digest, params[:id]) && !user.activated?
      user.update_attribute(:activated_at, Time.zone.now)
      user.update_attribute(:activated, true)
      log_in(user)
      flash[:success] = "Thank you for activating your account. You are now logged in."
      redirect_to(user)
    else
      flash[:danger] = "Invalid activation link."
      redirect_to(root_url)
    end
  end
end
