require 'isbndb'

class BooksController < ApplicationController
  before_filter :authorise, :except => [:index, :all, :covers, :show]
  verify  :method => [:post, :put, :delete],
          :only => [:destroy, :create, :update],
          :redirect_to => { :action => :index }
  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_if_not_found
  
  respond_to :html, :except => :autofill
  respond_to :atom, :only   => :index
  respond_to :json, :only   => :autofill
  
  def index
    @books = Book.list_books(params[:page], 10)
    
    unless admin? || @books.empty? || has_flash?
      last_updated = @books.sort {|a, b| a.updated_at <=> b.updated_at }.last
      
      fresh_when :etag => @books,
                 :last_modified => last_updated.updated_at.utc,
                 :public => true
    end
  end
  
  def covers
    @title = "Browse covers"
    @books = Book.list_covers(params[:page], 20)
  end
  
  def show
    @book  = Book.find_by_permalink(params[:id])
    maybe_raise_404(@book)
    @title = @book.title
    
    unless admin? || has_flash?
      fresh_when :etag => @book,
                 :last_modified => @book.updated_at.utc,
                 :public => true
    end
  end
  
  def new
    @title = "Add book"
    @book  = Book.new
  end
  
  def create
    @book = Book.new(params[:book])
    render :action => "new" and return unless @book.save
    
    flash[:notice] = "Book successfully created."
    redirect_to book_path(@book)
  end
  
  def edit
    @title = "Edit book"
    @book  = Book.find_by_permalink(params[:id])
    maybe_raise_404(@book)
    render :layout => false if request.xhr?
  end
  
  def update
    @book = Book.find_by_permalink(params[:id])
    maybe_raise_404(@book)
    render :action => "edit", :layout => !request.xhr? and return unless @book.update_attributes(params[:book])
    
    if request.xhr?
      if request.referer == request.url
        render :action => "show", :layout => false
      else
        render :partial => "books/book", :object => @book
      end
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
  
  def autofill
    begin
      @book = ISBNdb::Book.get(params[:isbn].gsub(/\D/, ""))
      render :json => @book.to_json
    rescue ISBNdb::BookNotFoundError, ISBNdb::ServiceNotAvailableError
      render :json => {}, :status => 404
    end
  end
  
  protected
  
  def redirect_if_not_found
    logger.error("Attempt to access invalid book #{params[:id]}")
    flash[:alert] = "Sorry, the system couldn&#8217;t find what you were looking for.".html_safe
    redirect_to root_path
  end
end
