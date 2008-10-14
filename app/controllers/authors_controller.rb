class AuthorsController < ApplicationController
  before_filter :authorise, :except => [:index, :show]
  verify  :method => [:post, :put, :delete],
          :only => [:destroy, :create, :update],
          :redirect_to => { :action => :index }
  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_if_not_found
    
  def index
    respond_to do |f|
      f.js { @authors = Author.find(:all,
        :conditions => ['name LIKE ?', "%#{params[:search]}%"]) }
      
      f.xml do
        @authors = Author.find(:all)
        options = {:except => [:id], :include => {:books => {:except => [:id, :author_id]}}}
        render :xml => @authors.to_xml(options)
      end
      
      f.html do
        @authors = Author.list_authors(params[:page], 20)
      end
    end
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
    @author = Author.find_by_permalink(params[:id])
    
    if @author.books.blank?
      @author.destroy
      flash[:notice] = "Author deleted." and redirect_to authors_path
    else
      flash[:alert] = "Only authors with no books may be deleted." and redirect_to author_path(@author)
    end
  end
  
  protected
  
  def redirect_if_not_found
    logger.error("Attempt to access invalid author #{params[:id]}")
    flash[:alert] = "Sorry, the system couldn&#8217;t find what you were looking for."
    redirect_to authors_path
  end
end
