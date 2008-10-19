require 'urlify'

class Book < ActiveRecord::Base
  attr_accessible :title, :comment, :cover_url, :isbn, :author_names
  has_many :authorships
  has_many :authors, :through => :authorships
  before_validation :generate_permalink, :clean_isbn
  
  validates_presence_of :title, :permalink, :authors
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
  
  def self.list_books(page, per_page, options = {})
    options.merge!({:include => {:authorships => :author}})
    with_scope :find => options do
      paginate :per_page => per_page, :page => page
    end
  end
  
  def author_names
    authors.map {|a| a.name}.join(", ") if authors
  end
  
  def author_names=(names)
    self.authors = names.split(/\s*,\s*/).map do |name|
      unless name.blank?
        Author.find_or_initialize_by_name(name)
      end
    end
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
