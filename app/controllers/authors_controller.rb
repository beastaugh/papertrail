class AuthorsController < ApplicationController
  before_filter :authorise, :except => [:index, :show]
  verify  :method => [:post, :put, :delete],
          :only => [:destroy, :create, :update],
          :redirect_to => { :action => :index }
  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_if_not_found
  # caches_page :index, :show, :if => Proc.new { |c| c.request.format.atom? }
  # cache_sweeper :author_sweeper, :only => [:create, :update, :destroy]
  
  def index
    @title   = "Authors"
    @authors = Author.list_authors(params[:page], 20)
    
    unless admin? || has_flash?
      last_modified = @authors.map {|a| a.updated_at }.sort.last
      
      fresh_when :etag => @authors,
                 :last_modified => last_modified,
                 :public => true
    end
  end
  
  def show
    @author = Author.find_by_permalink(params[:id])
    maybe_raise_404(@author)
    @title  = @author.name
    
    unless admin? || has_flash?
      books_updated = @author.books.to_a.map {|b| b.updated_at }
      last_modified = books_updated.push(@author.updated_at).sort.last
      
      fresh_when :etag => @author,
                 :last_modified => last_modified,
                 :public => true
    end
  end
  
  def new
    @title  = "Add author"
    @author = Author.new
  end
  
  def create
    @author = Author.new(params[:author])
    render :action => "new" and return unless @author.save
    
    flash[:notice] = "Author successfully added."
    redirect_to author_path(@author)
  end
  
  def edit
    @title  = "Edit author"
    @author = Author.find_by_permalink(params[:id])
    maybe_raise_404(@author)
    render :layout => false if request.xhr?
  end
  
  def update
    @author = Author.find_by_permalink(params[:id])
    maybe_raise_404(@author)
    
    render :action => "edit" and return unless @author.update_attributes(params[:author])
    
    if request.xhr?
      render :partial => "authors/author", :object => @author and return unless request.referer == request.url
      render :action => "show", :layout => false and return
    else
      flash[:notice] = "Author info updated." and redirect_to author_path(@author)
    end
  end
  
  def destroy
    @author = Author.find_by_permalink(params[:id])
    maybe_raise_404(@author)
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
    flash[:alert] = "Sorry, the system couldn&#8217;t find what you were looking for.".html_safe
    redirect_to authors_path
  end
end
