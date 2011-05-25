class AddCreatedAtAndUpdatedAtFieldsToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :created_at, :datetime
    add_column :authors, :updated_at, :datetime
    
    Author.all.each do |author|
      books = author.books
      
      if books
        last_book = books.last
        author.created_at = last_book.created_at
        author.updated_at = last_book.updated_at
      else
        now = Time.now
        author.created_at = now
        author.updated_at = now
      end
      
      author.save!
    end
  end
end
