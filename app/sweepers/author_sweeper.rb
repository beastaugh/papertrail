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
    
    # Expire XML and Atom feed caches
    expire_page "/authors.xml"
    expire_page "/authors/#{author.permalink}.xml"
    
    # Expire book pages that may list the author
    expire_page "/books.atom"
    expire_page "/books.xml"
    author.books.each do |book|
      expire_page "/books/#{book.permalink}.xml"
    end
  end
end
