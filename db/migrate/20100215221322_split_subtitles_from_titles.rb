class SplitSubtitlesFromTitles < ActiveRecord::Migration
  class Book < ActiveRecord::Base
  end
  
  def self.up
    add_column :books, :subtitle, :string
    
    begin
      Book.all.each do |book|
        titles = book.title.split(/\s*:\s+/, 2)
        
        if titles.length > 1
          book.title, book.subtitle = titles
          book.save
        end
      end
    rescue ActiveRecord::RecordNotSaved
      puts "Migration failed; could not save subtitle." and return
    end
  end
  
  def self.down
    begin
      Book.all.each do |book|
        unless book.subtitle.blank?
          book.title = book.title + ": " + book.subtitle
          book.save
        end
      end
    rescue ActiveRecord::RecordNotSaved
      puts "Migration failed; could not repair titles." and return
    end
    
    remove_column :books, :subtitle
  end
end
