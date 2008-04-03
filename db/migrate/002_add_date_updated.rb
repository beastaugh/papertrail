class AddDateUpdated < ActiveRecord::Migration
  def self.up
    rename_column :books, :date_added, :created_at
    add_column :books, :updated_at, :datetime
  end

  def self.down
    rename_column :books, :created_at, :date_added
    add_column :books, :updated_at
  end
end