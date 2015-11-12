module SessionsHelper

  # method to login the user
  def log_in(user)
    session[:user_id] = user.id
  end

  # method to remember a user in persistence session
  def remember(user)
    user.remember
    # cookies[:remember_token] = { value: some_token, expires: 20.years.from_now.utc }
    # which is the same as cookies.permanent[:remember_token] = remember_token
    # signed encrypts the cookie before placing it in the browser
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token  # saving the remember_token to cookie
  end

  # method to return true if user is the current_user, false otherwise
  def current_user?(user)
    user == current_user
  end

  # method to return the user corresponding to the remember token in cookie
  def current_user
    # modified current_user to incorporate remember_me feature
    # 1. if session[:user_id] exists, assign to @current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) # 2. if not above, look for the cookies[:user_id] from the browser
      # find the user_id stored in the cookies in the database
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  # returns true if the user is logged in, false otherwise
  def logged_in?
    # if current_user is nil (true), returns false
    # if current_user is not nil (false), returns true
    !current_user.nil?
  end

  # method to log out the current user
  def log_out
    forget(current_user)
    session.delete(:user_id)  #this also works session[:user_id] = nil
    # this is needed if @current_user is created before the destroy action
    # (which is not in the case now. this is for completeness and security reason)
    @curret_user = nil
  end

  # method to forget the current user
  def forget(user)
    user.forget # `forget` from user model
    cookies.delete(:user_id)          # equally valid cookies[:user_id] = nil
    cookies.delete(:remember_token)   # equally valid cookies[:remember_token] = nil
  end
end
