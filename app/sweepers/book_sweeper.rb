# Sweeper for books pages
# 
# Cleans up page caches when books are added, removed or edited.
class BookSweeper < ActionController::Caching::Sweeper
  observe Book
  
  # If the sweeper detects that a book was saved, call this
  def after_save(book)
    expire_cache(book)
  end

  # If the sweeper detects that a book was deleted, call this
  def after_destroy(book)
    expire_cache(book)
  end
  
  private
  
  def expire_cache(book)
    # Expire the home page
    expire_page('/index')
    expire_page('books/index')
    
    # Expire the 'All books' page too
    expire_page(:controller => 'books', :action => 'all')
    
    # And the 'Browse covers' page
    expire_page(:controller => 'books', :action => 'covers')
    
    # Finally expire the book page
    expire_page(:controller => 'books', :action => 'show', :id => book.permalink)
  end  
end
