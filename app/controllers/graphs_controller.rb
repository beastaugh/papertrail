class GraphsController < ApplicationController
  
  def index
    redirect_to "/graphs/frequency"
  end
  
  def frequency
    response.content_type = "application/xhtml+xml"
    
    books = Book.count(:created_at,
      :conditions => ["created_at > ?", 1.year.ago],
      :group => :created_at)
    
    start = Time.now.month
    month_mapping = (1..12).map do |i|
      num = (start + i) % 12
      (num > 0) ? num : 12
    end
    
    @months = month_mapping.map {|m| { :month => m, :books => 0 } }
    
    books.each do |book|
      @months[month_mapping.index(book.first.month)][:books] += 1
    end
    
    @maxheight = @months.map { |m|
      m[:books]
    }.sort.last
  end
end
