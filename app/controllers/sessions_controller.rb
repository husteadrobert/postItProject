class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])
    password = params[:password]
    if user && user.authenticate(password)
      session[:user_id] = user.id
      flash[:notice] = "You have logged in as #{user.username}"
      redirect_to root_path
    else
      flash[:error] = "Username or Password are Incorrect"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have logged out"
    redirect_to root_path
  end

end