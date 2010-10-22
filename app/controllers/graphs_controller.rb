class GraphsController < ApplicationController
  
  def index
    redirect_to "/graphs/frequency"
  end
  
  def frequency
    return if fragment_exist? "graphs/frequency"
    
    @title = "Frequency"
    @books = Book.last_year
    
    now          = Time.now
    this_month   = now.month
    this_year    = now.year
    
    distribution = (1..12).map {|i|
      {:name => Time::RFC2822_MONTH_NAME[i - 1], :num_books => 0, :index => i}
    }
    
    @last_year = @books.inject(distribution) {|dist, book|
      created_at = book.created_at
      
      unless created_at.month == this_month && created_at.year < this_year
        dist[created_at.month - 1][:num_books] += 1
      end
      
      dist
    }.partition {|m| m[:index] > this_month }.flatten
  end
  
end
