require 'rest_client'
require 'nokogiri'
require 'json'

module ISBNdb
  DOMAIN  = "isbndb.com"
  API_KEY = APP_CONFIG["isbndb_api_key"] || ""
  
  class ServiceNotAvailableError < StandardError; end
  class BookNotFoundError < StandardError; end
  
  class URI
    attr_accessor :protocol, :domain, :path, :params
    
    def initialize(opts = {})
      @protocol = opts[:protocol] || 'http'
      @domain   = opts[:domain]   || DOMAIN
      @path     = opts[:path]     || []
      @params   = opts[:params]   || {}
    end
    
    def to_s
      qs = @params.inject("?") do |qs, (k, v)|
        qs + (qs.length < 2 ? "" : "&") + k + "=" + v
      end
      
      @protocol + "://" + @domain +
        (@path.empty? ? "" : "/" + @path.join("/")) +
        (@params.empty? ? "" : qs)
    end
  end
  
  class Book
    def initialize
      @api_key = API_KEY
      @uri     = URI.new :path => ["api", "books.xml"],
        :params => {
          :access_key => @api_key,
          :index1     => "isbn"
        }
    end
    
    def isbn=(isbn)
      @isbn = isbn
      @uri.params[:value1] = @isbn
    end
    
    def get
      begin
        data = RestClient.get(@uri.to_s)
      rescue
        raise ServiceNotAvailableError
      end
      
      parse(data || "")
    end
    
    def parse(response)
      @xml = Nokogiri::XML(response)
      
      raise BookNotFoundError if @xml.css("BookData").empty?
      
      @title   = @xml.css("Title").first.content
      @authors = @xml.css("AuthorsText")[0].content.split(/\s*,\s*/)
      
      title_long = @xml.css("TitleLong")
      
      if title_long.empty?
        @subtitle = ""
      else
        @subtitle = title_long.first.content.split(/\s*:\s*/, 2).last
      end
      
      self
    end
    
    def to_json(*a)
      {
        :title        => @title,
        :subtitle     => @subtitle,
        :author_names => @authors.join(", ")
      }.to_json(*a)
    end
    
    def self.get(isbn)
      book      = self.new
      book.isbn = isbn
      book.get
    end
  end
end
