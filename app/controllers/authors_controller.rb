class AuthorsController < ApplicationController
  before_filter :authorise, :except => [:index, :show]
  verify  :method => [:post, :put, :delete],
          :only => [:destroy, :create, :update],
          :redirect_to => { :action => :index }
  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_if_not_found
    
  def index
    if true
      @authors = Author.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
    else
      @authors = Author.list_authors
    end
#    respond_to_defaults(@authors, :except => [:id])
  end
  
  def show
    @author = Author.find_by_permalink(params[:id])
  end
  
  def new
    @author = Author.new
  end

  def create
    @author = Author.new(params[:author])    
    render :action => "new" and return unless @author.save

    flash[:notice] = "Author successfully added."
    redirect_to author_path(@author)
  end

  def edit
    @author = Author.find_by_permalink(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @author = Author.find_by_permalink(params[:id])
    render :action => "edit" and return unless @author.update_attributes(params[:author])
    
    if request.xhr?
      render :partial => "authors/author", :locals => {:author => @author} and return unless request.referer == request.url
      render :action => "show", :layout => false and return
    else
      flash[:notice] = "Author info updated." and redirect_to author_path(@author)
    end
  end

  def destroy
    Author.find(params[:id]).destroy
    flash[:notice] = "Author deleted."
    redirect_to authors_path
  end
  
  protected
  
  def redirect_if_not_found
    logger.error("Attempt to access invalid author #{params[:id]}")
    flash[:alert] = "Sorry, the system couldn&#8217;t find what you were looking for."
    redirect_to authors_path
  end
end
