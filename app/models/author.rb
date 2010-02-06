class Author < ActiveRecord::Base
  attr_accessible :name, :note
  has_many :authorships
  has_many :books, :through => :authorships
  before_validation :generate_permalink
  validates_presence_of :name, :permalink
  validates_uniqueness_of :name, :permalink
  validates_format_of :permalink,
                      :with => /^[\w-]+$/
  
  # Lists all authors in the database.
  def self.list_authors(page, per_page)
    includes(:authorships => :book).
      order(:name).
      paginate(:per_page => per_page, :page => page)
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
