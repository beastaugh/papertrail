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
    expire_fragment %r{books/page/\d+}
    expire_fragment %r{books/#{book.permalink}(\.(page|item))?(_xhr)?}
    
    # Expire XML and Atom feed caches
    expire_page "/books.atom"
    expire_page "/books.xml"
    expire_page "/books/#{book.permalink}.xml"
    
    # Expire frequency graph
    expire_page "/graphs/frequency.svg"
    
    # Expire author pages that may list the book
    expire_page "/authors.xml"
    book.authors.each do |author|
      expire_page "/authors/#{author.permalink}.xml"
    end
  end
end
