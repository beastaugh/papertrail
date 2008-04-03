class SessionsController < ApplicationController
  def create
    session[:password] = params[:password]
    if admin?
      flash[:notice] = "Successfully logged in."
      redirect_to root_path
    else
      flash[:notice] = "Incorrect password."
      redirect_to login_path
    end
  end
  
  def destroy
    reset_session
    flash[:notice] = "Successfully logged out."
    redirect_to login_path
  end
end