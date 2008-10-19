class CreateAuthorships < ActiveRecord::Migration
  def self.up
    create_table :authorships do |t|
      t.integer :author_id, :book_id, :weight
      t.timestamps
    end
    
    add_index :authorships, :author_id
    add_index :authorships, :book_id
    
    begin
      Book.all.each do |book|
        authorship = Authorship.new({
          :author_id => book.author_id,
          :book_id => book.id,
          :weight => 0 })
        authorship.save!
      end
    rescue ActiveRecord::RecordNotSaved
      puts "Migration failed; could not save authorship relation." and return
    end
    
    remove_column :books, :author_id
  end
  
  def self.down
    add_column :books, :author_id, :integer
    
    begin
      Book.all(:include => :authorships).each do |book|
        first_authorship = book.authorships.sort_by {|a| a.weight}.first
        book.author_id = first_authorship.author_id
        book.save!
      end
    rescue ActiveRecord::RecordNotSaved
      puts "Migration failed; could not save author ID." and return
    end
    
    drop_table :authorships
  end
end
