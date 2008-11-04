class Authorship < ActiveRecord::Base
  belongs_to :author
  belongs_to :book
  validates_presence_of :author_id, :book_id
  validates_uniqueness_of :author_id, :scope => :book_id
end
