require 'urlify'

class Book < ActiveRecord::Base
  belongs_to :author
  before_validation :generate_permalink, :clean_isbn
  
  validates_presence_of :title, :author, :permalink
  validates_uniqueness_of :title, :permalink
  validates_format_of :cover_url,
                      :with => %r{\.(gif|jpg|png)$}i,
                      :allow_blank => true,
                      :message => "must be a URL for a GIF, JPEG or PNG image."
  validates_format_of :permalink,
                      :with => %r{\A[a-z\d][a-z\d\_\-]*[a-z\d]\z}
  validates_format_of :isbn,
                      :with => /^(\d{13}|\d{10})?$/,
                      :message => "must be a valid ISBN with 10 or 13 digits."
  
  # Lists all books in the database.
  def self.list_books(options = {})
    with_scope :find => options do
      find(:all)
    end
  end
  
  def author_name
    author.name if author
  end
  
  def author_name=(name)
    self.author = Author.find_or_create_by_name(name) unless name.blank?
  end
    
  def clean_isbn
    self.isbn = self.isbn.gsub(/\D/, "")
  end
  
  # Enables pretty permalinks.
  def to_param
    permalink
  end
  
  protected
  
  # Generates permalinks from the book's name.
  def generate_permalink
    unless title.blank?
      self.permalink = title.urlify
    end
  end
end
