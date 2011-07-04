module SessionsHelper
  
  def sign_in(user)
    #cookies.permanent.signed[:remember_token] = [user.id, user.password_salt]
    
    # Store user id in the session
    session[:user_id] = user.id
  end
  
  def sign_out
    #cookies.delete(:remember_token)
    
    session[:user_id] = nil
  end
  
  # Return the currently logged in user, or nil
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def signed_in?
    !current_user.nil?
  end
end
