class Authorship < ActiveRecord::Base
  attr_accessible :author_id, :book_id, :weight
  belongs_to :author
  belongs_to :book
  before_validation :generate_weight
  validates_presence_of :author_id, :book_id, :weight
  
  protected
  
  def generate_weight
    self.weight = 0
  end
end
