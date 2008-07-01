class BooksController < ApplicationController
  before_filter :authorise, :except => [:index, :all, :covers, :show]
  verify  :method => [:post, :put, :delete],
          :only => [:destroy, :create, :update],
          :redirect_to => { :action => :index }
  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_if_not_found
  # Caching is currently disabled
  # caches_page :index, :all, :covers, :show
  # cache_sweeper :book_sweeper, :only => [:create, :update, :destroy]
  
  def index
    @books = Book.list_books :limit => 5, :order => "created_at DESC"    
    respond_to_defaults(@books, :except => [ :id, :author_id ])
  end
  
  def all
    @books = Book.list_books :order => "title ASC"
  end
  
  def covers
    @books = Book.list_books :conditions => "cover_url <> ''", :order => "title ASC"
  end
  
  def show
    @book = Book.find_by_permalink(params[:id])
  end
  
  def new
    @book = Book.new
  end

  def create
    @book = Book.new(params[:book])
    render :action => "new" and return unless @book.save
    
    flash[:notice] = "Book successfully created."
    redirect_to book_path(@book)
  end

  def edit
    @book = Book.find_by_permalink(params[:id])
    render :layout => false if request.xhr?
  end

  def update
    @book = Book.find_by_permalink(params[:id])
    render :action => "edit" and return unless @book.update_attributes(params[:book])
    
    if request.xhr?
      render :partial => "books/book", :locals => {:book => @book} and return unless request.referer == request.url
      render :action => "show", :layout => false and return
    else
      flash[:notice] = "Book updated." and redirect_to book_path(@book)
    end
  end

  def destroy
    Book.find_by_permalink(params[:id]).destroy
    flash[:notice] = "Book deleted."
    redirect_to root_path
  end
  
  protected
  
  def redirect_if_not_found
    logger.error("Attempt to access invalid book #{params[:id]}")
    flash[:alert] = "Sorry, the system couldn&#8217;t find what you were looking for."
    redirect_to root_path
  end
end
