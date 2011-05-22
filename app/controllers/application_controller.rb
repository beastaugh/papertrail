class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :admin?
  helper_method :current_user
  
  protected
  
  def authorise
    unless admin?
      flash[:error] = "Unauthorised access."
      redirect_to root_path
    end
  end
  
  def admin?
    current_user && current_user.is_admin?
  end
  
  def maybe_raise_404(resource)
    raise ActiveRecord::RecordNotFound, "Page not found" if resource.nil?
  end
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
