# Sweeper for books pages
# 
# Cleans up page caches when books are added, removed or edited.
class BookSweeper < ActionController::Caching::Sweeper
  observe Book
  
  # Expire cache if a book is added or updated
  def after_save(book)
    expire_cache(book)
  end
  
  # Expire cache if a book is deleted
  def after_destroy(book)
    expire_cache(book)
  end
  
  private
  
  def expire_cache(book)
    # Expire cached index and show fragments
    expire_fragment %r{books/#{book.permalink}(\.(page|item))?(_xhr)?}
    
    # Expire Atom feed
    expire_page "/books.atom"
    
    # Expire reading frequency table
    expire_fragment "graphs/frequency"
    
    # Expire author fragments that might list the book
    book.authors.each do |author|
      expire_fragment %r{authors/#{author.permalink}(\.(page|item))?(_xhr)?}
    end
  end
end
