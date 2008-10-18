class ApplicationController < ActionController::Base
  session :session_key => '_papertrail_session_id'
  filter_parameter_logging "password"  
  helper_method :admin?
    
  protected
  
  def authorise
    unless admin?
      flash[:error] = "Unauthorised access."
      redirect_to root_path
    end
  end
  
  def admin?
    if APP_CONFIG['perform_authentication']
      session[:password] == APP_CONFIG["password"]
    else
      true
    end
  end
  
  def respond_to_defaults(resource, options = {})
    respond_to do |f|
      f.html
      f.atom
      f.xml { render :xml => resource.to_xml(options) }
    end
  end
end
