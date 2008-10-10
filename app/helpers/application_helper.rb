module ApplicationHelper
  def smartypants(text)
    text.blank? ? "" : RubyPants.new(text).to_html
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def sitetitle
    unless APP_CONFIG["title"].blank?
      h(APP_CONFIG["title"])
    else
      "Books"
    end
  end
  
  def headcontent
    # No additional header content yet!
  end
  
  def papertrail_javascript
    if admin?
      minify = ".min" if RAILS_ENV == 'production'

      javascript_include_tag(
        "jquery-1.2.6#{minify}.js",
        "edit.js",
        "application.js"
      )
    end
  end
  
  def sitename_tag
    unless sitetitle.blank?
      tag = current_page?(root_path) ? "h1" : "p"      
      content_tag tag, link_to(sitetitle, root_path, :rel => "home"), :id => "title"
    end
  end
  
  def navbar
    navlinks = [
      { :id => "all-books", :name => "All books", :path => books_all_path },
      { :id => "book-covers", :name => "Covers", :path => books_covers_path },
      { :id => "authors", :name => "Authors", :path => authors_path }
      # Additional navbar links go here
    ]
    
    adminlinks = [
      { :id => "new-book", :name => "Add book", :path => new_book_path }
    ]
    
    navlinks += adminlinks if admin?
    
    nav = Builder::XmlMarkup.new :indent => 2
    
    nav.ul :id => "nav" do
      navlinks.each do |link|
        nav.li :id => link[:id] do
          unless current_page? link[:path]
            nav.a link[:name], :href => link[:path]
          else
            nav.a link[:name], :href => link[:path], :class => "current"
          end
        end
      end
    end
  end
  
  def blurb
    blurb = APP_CONFIG["blurb"]
    
    unless blurb.blank?
      content_tag(:div, sanitize(smartypants(markdown(APP_CONFIG["blurb"]))), :id => "blurb")
    end
  end
  
  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => capture(&block))
    concat(render(:partial => partial_name, :locals => options), block.binding)
  end
  
  def editable_content_wrapper(options = {}, &block)
    yield and return if request.xhr?
    block_to_partial('shared/editable_wrapper', options, &block)
  end
  
  def book_page_link(book, link_options = {})
    link_to( link_options[:link_name] || sanitize(smartypants(book.title)), book_path(book) )
  end
  
  def author_page_link(author)
    link_to sanitize(smartypants(author.name)), author_path(author)
  end
end

begin
  require 'lib/view_extras'
rescue MissingSourceFile
  #
end
