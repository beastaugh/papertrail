class ApplicationController < ActionController::Base
  filter_parameter_logging "password"  
  helper_method :admin?
  after_filter :set_content_type
  
  protected
  
  def authorise
    unless admin?
      flash[:error] = "Unauthorised access."
      redirect_to root_path
    end
  end
  
  def admin?
    request.ssl? || !APP_CONFIG['perform_authentication']
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
  
  def set_content_type
    response.charset = "utf-8"
  end
end
