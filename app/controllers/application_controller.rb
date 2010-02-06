class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :admin?
  
  protected
  
  def authorise
    unless admin?
      flash[:error] = "Unauthorised access."
      redirect_to root_path
    end
  end
  
  def admin?
    auth = APP_CONFIG['perform_authentication']
    request.ssl? || (auth.nil? ? false : !auth)
  end
  
  def maybe_raise_404(resource)
    raise ActiveRecord::RecordNotFound, "Page not found" if resource.nil?
  end
  
  def respond_to_defaults(resource, options = {})
    respond_to do |f|
      f.html
      f.xml { render :xml => resource.to_xml(options) }
    end
  end
end
