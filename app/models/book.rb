require 'urlify'

class Book < ActiveRecord::Base
  belongs_to :author
  attr_accessor :new_author_name
  before_validation :generate_permalink, :create_author_from_name
  
  validates_presence_of :title, :author, :comment, :permalink
  validates_uniqueness_of :title, :permalink
  validates_format_of :cover_url,
                      :with => %r{\.(gif|jpg|png)$}i,
                      :allow_blank => true,
                      :message => "must be a URL for a GIF, JPEG or PNG image."
  validates_format_of :permalink,
                      :with => %r{\A[a-z\d][a-z\d\_\-]*[a-z\d]\z}
  
  # Lists all books in the database.
  def self.list_books(options = {})
    with_scope :find => options do
      find(:all)
    end
  end
  
  # Creates an author with the supplied name.
  def create_author_from_name
    unless new_author_name.blank?
      create_author(:name => new_author_name)
    end
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