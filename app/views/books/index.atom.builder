atom_feed :language => "en-GB", :schema_date => "2008" do |feed|
  feed.title APP_CONFIG['title']
  feed.updated((@books.first.updated_at rescue nil))
  feed.author do |author|
    author.name APP_CONFIG['author']
  end
  
  for book in @books
    feed.entry(book) do |entry|
      entry.title book.title
      entry.content :type => "xhtml" do |x|
        x << sanitize(markdown(book.comment))
      end
    end
  end
end
