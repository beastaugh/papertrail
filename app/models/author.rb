require 'urlify'

class Author < ActiveRecord::Base
  has_many :books
  before_validation :generate_permalink
  validates_presence_of :name, :permalink
  validates_uniqueness_of :name, :permalink
  validates_format_of :permalink,
                      :with => %r{\A[a-z\d][a-z\d\_\-]*[a-z\d]\z}

  # Lists all authors in the database.
  def self.list_authors
    find(:all, :order => "name ASC")
  end
  
  # Enables pretty permalinks
  def to_param
    permalink
  end
  
  protected
  
  # Generates permalinks from the author's name.
  def generate_permalink
    unless name.blank?
      self.permalink = name.urlify
    end
  end
end