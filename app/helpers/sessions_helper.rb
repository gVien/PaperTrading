module SessionsHelper

  # method to login the user
  def log_in(user)
    session[:user_id] = user.id
  end

  # method to return current user that is in session (if any)
  def current_user
    # find method raises an error if session[:user_id] is nil
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # returns true if the user is logged in, false otherwise
  def logged_in?
    # if current_user is nil (true), returns false
    # if current_user is not nil (false), returns true
    !current_user.nil?
  end

  # method to log out the current user
  def log_out
    session.delete(:user_id)  #this also works session[:user_id] = nil
    # this is needed if @current_user is created before the destroy action
    # (which is not in the case now. this is for completeness and security reason)
    @curret_user = nil
  end
end
