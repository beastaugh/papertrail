class Author < ActiveRecord::Base
  attr_accessible :name, :note
  has_many :authorships
  has_many :books, :through => :authorships
  before_validation :generate_permalink
  validates_presence_of :name, :permalink
  validates_uniqueness_of :name, :permalink
  validates_format_of :permalink,
                      :with => %r{\A[a-z\d][a-z\d\_\-]*[a-z\d]\z}
    
  # Lists all authors in the database.
  def self.list_authors(page, per_page, options = {})
    options.merge!({:include => {:authorships => :book}, :order => :name})
    with_scope :find => options do
      paginate :per_page => per_page, :page => page
    end
  end
  
  # Enables pretty permalinks
  def to_param
    permalink
  end
  
  protected
  
  # Generates permalinks from the author's name.
  def generate_permalink
    unless name.blank?
      self.permalink = URLify.urlify(name)
    end
  end
end
