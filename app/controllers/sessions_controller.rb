class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      sign_in user
      redirect_to user, :notice => "Logged in!"      
    else
      flash.now.alert = "Invalid email or password"
      render "new"      
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url, :notice => "Logged out!"
  end

end
