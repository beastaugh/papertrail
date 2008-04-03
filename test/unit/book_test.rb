require File.dirname(__FILE__) + '/../test_helper'

class BookTest < Test::Unit::TestCase
  fixtures :books
  
  def test_author_creation
    assert_equal 1, 1
  end
  
  def test_permalink_generation
    #
  end
end
