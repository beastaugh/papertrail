class ConvertIsbnsTo13DigitIntegers < ActiveRecord::Migration
  def self.up
    change_column :books, :isbn, :integer
  end

  def self.down
    change_column :books, :isbn, :string
  end
end
