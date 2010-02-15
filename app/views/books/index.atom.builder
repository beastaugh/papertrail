atom_feed :language => "en-GB", :schema_date => "2008" do |feed|
  feed.title APP_CONFIG['title']
  feed.updated((@books.first.updated_at rescue nil))
  feed.author do |author|
    author.name APP_CONFIG['author']
  end
  
  for book in @books
    feed.entry(book) do |entry|
      entry.title book.full_title
      entry.content markdown(book.comment), :type => "html"
    end
  end
end
