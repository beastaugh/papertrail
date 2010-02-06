class GraphsController < ApplicationController
  
  def index
    redirect_to "/graphs/frequency"
  end
  
  def frequency
    return if fragment_exist? "graphs/frequency"
    
    @title = "Frequency"
    @books = Book.last_year
    
    @last_year = @books.inject([]) do |distribution, book|
      name = Time::RFC2822_MONTH_NAME[book.created_at.month - 1]
      
      if distribution.last.nil? || distribution.last[:name] != name
        distribution << {:name => name, :num_books => 1}
      else
        distribution.last[:num_books] += 1
      end
      
      distribution
    end
  end
  
end
