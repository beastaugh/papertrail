class GraphsController < ApplicationController
  FREQ_GRAPH_PATH = Rails.public_path + "/graphs/frequency.svg"
  
  def index
    redirect_to "/graphs/frequency"
  end
  
  def frequency
    return if File.exists?(FREQ_GRAPH_PATH)
    
    @books = Book.find :all, :conditions => ["created_at > ?", 1.year.ago]
    
    @book_distribution = @books.inject([]) do |dist, book|
      if dist.last.nil? || dist.last[:month] != book.created_at.month
        dist << {:month => book.created_at.month, :books => 1}
      else
        dist.last[:books] += 1
      end
      
      dist
    end
    
    len = @book_distribution.length
    @book_distribution = @book_distribution[len - 12, len]
    maxheight = @book_distribution.map {|m| m[:books] }.sort.last
    
    File.open(FREQ_GRAPH_PATH, "w+") do |f|
      f.puts @template.yearly_graph(@book_distribution, :maxheight => maxheight)
    end
  end
end
