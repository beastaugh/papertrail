class BooksController < ApplicationController
  before_filter :authorise, :except => [:index, :all, :covers, :show]
  verify  :method => [:post, :put, :delete],
          :only => [:destroy, :create, :update],
          :redirect_to => { :action => :index }
  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_if_not_found
  caches_page :index, :show, :if => Proc.new { |c| c.request.format.xml? || c.request.format.atom? }
  cache_sweeper :book_sweeper, :only => [:create, :update, :destroy]
  
  API_ATTRS = {:except => :id,
    :include => {:authors => {:except => :id}}}
  
  def index
    @books = Book.list_books(params[:page], 10, :order => "created_at DESC")
    respond_to do |f|
      f.html
      f.atom
      f.xml { render :xml => @books.to_xml(API_ATTRS) }
    end
  end
  
  def covers
    @books = Book.list_books(params[:page], 20, :conditions => "cover_url <> ''", :order => "title ASC")
  end
  
  def show
    @book = Book.find_by_permalink(params[:id])
    maybe_raise_404(@book)
    respond_to_defaults(@book, API_ATTRS)
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
    maybe_raise_404(@book)
    render :layout => false if request.xhr?
  end

  def update
    @book = Book.find_by_permalink(params[:id])
    maybe_raise_404(@book)
    render :action => "edit", :layout => !request.xhr? and return unless @book.update_attributes(params[:book])
    
    if request.xhr?
      render "books/book", :locals => {:book => @book} and return unless request.referer == request.url
      render :action => "show", :layout => false and return
    else
      flash[:notice] = "Book updated." and redirect_to book_path(@book)
    end
  end

  def destroy
    @book = Book.find_by_permalink(params[:id])
    maybe_raise_404(@book)
    @book.destroy
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
