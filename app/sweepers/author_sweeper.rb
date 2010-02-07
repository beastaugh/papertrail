# Sweeper for author pages
# 
# Cleans up page caches when authors are added, removed or edited.
class AuthorSweeper < ActionController::Caching::Sweeper
  observe Author
  
  # Expire cache if an author is added or updated
  def after_save(author)
    expire_cache(author)
  end
  
  # Expire cache if an author is removed
  def after_destroy(author)
    expire_cache(author)
  end
  
  private
  
  def expire_cache(author)
    # Expire cached index and show fragments
    expire_fragment %r{authors/#{author.permalink}(\.(page|item))?(_xhr)?}
    
    # Expire reading frequency table
    expire_fragment "graphs/frequency"
    
    # Expire book feeds that might list the author
    expire_page "/books.atom"
    
    # Expire book fragments that might list the author
    author.books.each do |book|
      expire_fragment %r{books/#{book.permalink}(\.(page|item))?(_xhr)?}
    end
  end
end
