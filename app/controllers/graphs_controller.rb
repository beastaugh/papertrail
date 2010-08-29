class GraphsController < ApplicationController
  
  def index
    redirect_to "/graphs/frequency"
  end
  
  def frequency
    return if fragment_exist? "graphs/frequency"
    
    @title = "Frequency"
    @books = Book.last_year
    
    first_month  = @books.first.created_at.month
    distribution = (1..12).map {|i|
      {:name => Time::RFC2822_MONTH_NAME[i - 1], :num_books => 0, :index => i}
    }
    
    @last_year = @books.inject(distribution) {|dist, book|
      dist[book.created_at.month - 1][:num_books] += 1
      dist
    }.partition {|m| m[:index] >= first_month }.flatten
  end
  
end
