class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :books, :title
    add_index :books, :permalink
    add_index :books, :author_id
    add_index :books, :created_at
    
    add_index :authors, :name
    add_index :authors, :permalink
  end

  def self.down
    remove_index :books, :title
    remove_index :books, :permalink
    remove_index :books, :author_id
    remove_index :books, :created_at
    
    remove_index :authors, :name
    remove_index :authors, :permalink
  end
end
