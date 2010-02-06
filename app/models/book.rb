class Book < ActiveRecord::Base
  attr_accessible :title, :comment, :cover_url, :isbn, :author_names
  has_many :authorships
  has_many :authors, :through => :authorships, :order => :weight
  before_validation :generate_permalink, :clean_isbn
  
  validates_presence_of   :title, :permalink, :authors
  validates_uniqueness_of :title, :permalink
  
  validates_format_of     :cover_url,
                          :with => %r{\.(gif|jpg|png)$}i,
                          :allow_blank => true,
                          :message => "must be a URL for a GIF, JPEG or PNG image."
  
  validates_format_of     :permalink,
                          :with => /^[\w-]+$/
  
  validates_format_of     :isbn,
                          :with => /^(\d{13}|\d{10})?$/,
                          :message => "must be a valid ISBN with 10 or 13 digits."
  
  scope :since, lambda {|time| {:conditions => ["created_at > ?", time] }}
  
  after_save :save_authorship_ordering
  
  def self.list_books(page, per_page)
    includes(:authorships => :author).
      order("created_at DESC").
      paginate(:per_page => per_page, :page => page)
  end
  
  def self.list_covers(page, per_page)
    where("cover_url <> ''").
      order("title ASC").
      paginate(:per_page => per_page, :page => page)
  end
  
  def self.last_year
    since(1.year.ago)
  end
  
  def author_names
    authors.map {|a| a.name}.join(", ") if authors
  end
  
  def author_names=(names)
    @author_names = names.split(/\s*,\s*/).reject(&:blank?)
    self.authors = @author_names.map do |name|
      Author.find_or_create_by_name(name)
    end
  end
  
  def save_authorship_ordering
    self.authorships.each do |authorship|
      author = self.authors.select {|a| a.id == authorship.author_id }.first
      authorship.weight = self.author_names.index(author.name) || 0
      authorship.save
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
      self.permalink = URLify.urlify(title)
    end
  end
end
