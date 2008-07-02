class ConvertIsbnsBackToStrings < ActiveRecord::Migration
  def self.up
    change_column :books, :isbn, :string, :limit => 13
  end

  def self.down
    change_column :books, :isbn, :integer
  end
end
