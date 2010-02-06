class AuthorsController < ApplicationController
  before_filter :authorise, :except => [:index, :show]
  verify  :method => [:post, :put, :delete],
          :only => [:destroy, :create, :update],
          :redirect_to => { :action => :index }
  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_if_not_found
  # caches_page :index, :show, :if => Proc.new { |c| c.request.format.atom? }
  # cache_sweeper :author_sweeper, :only => [:create, :update, :destroy]
  
  API_ATTRS = {:except => :id,
    :include => {:books => {:except => :id}}}
  
  def index
    respond_to do |f|
      f.html do
        @title   = "Authors"
        @authors = Author.list_authors(params[:page], 20)
      end
    end
  end
  
  def show
    @author = Author.find_by_permalink(params[:id])
    maybe_raise_404(@author)
    @title  = @author.name
    respond_to_defaults(@author, API_ATTRS)
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
    maybe_raise_404(@author)
    @author = Author.find_by_permalink(params[:id])
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
    flash[:alert] = "Sorry, the system couldn&#8217;t find what you were looking for."
    redirect_to authors_path
  end
end
