require 'literate_join'

module ApplicationHelper
  def markdown(text)
    text.blank? ? "" : Markdown.new(text).to_html.html_safe
  end
  
  def smartdown(text)
    text.blank? ? "" : Markdown.new(text, :smart).to_html.html_safe
  end
  
  def lang(page_lang)
    content_for(:lang) { page_lang }
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def sitetitle
    unless APP_CONFIG["title"].blank?
      APP_CONFIG["title"]
    else
      "Books"
    end
  end
  
  def application_javascript
    core  = ["jquery-1.6.min.js"]
    dev   = ["edit.js", "graphs.js", "application.js"]
    build = ["live/app-min.js"]
    files = core.concat Rails.env.production? ? build : dev
    
    javascript_include_tag(files)
  end
  
  def sitename_tag
    unless sitetitle.blank?
      tag = current_page?(root_path) ? "h1" : "p"      
      content_tag tag, link_to(sitetitle, root_path, :rel => "home"), :id => "title"
    end
  end
  
  def navbar
    navlinks = [
      { :id => "book-covers", :name => "Covers", :path => books_covers_path },
      { :id => "authors", :name => "Authors", :path => authors_path },
      { :id => "graphs", :name => "Graphs", :path => "/graphs/frequency" }]
    
    adminlinks = [
      { :id => "new-book", :name => "Add book", :path => new_book_path }]
    
    navlinks.concat(adminlinks) if admin?
    
    nav = Builder::XmlMarkup.new :indent => 2
    
    nav.ul(:id => "nav") {
        navlinks.each {|link|
          nav.li :id => link[:id] {
            class_name = current_page?(link[:path]) ? "current" : ""
            nav.a link[:name], :href => link[:path], :class => class_name
          }
        }
    }.html_safe
  end
  
  def blurb
    blurb = APP_CONFIG["blurb"]
    
    unless blurb.blank?
      content_tag(:div, smartdown(APP_CONFIG["blurb"]), :id => "blurb")
    end
  end
  
  def book_page_link(book, link_options = {})
    link_to( link_options[:link_name] || book.full_title, book_path(book) )
  end
  
  def author_page_link(author)
    link_to author.name, author_path(author)
  end
  
  def author_pages_link(authors)
    authors.map { |author|
      link_to author.name, author_path(author)
    }.literate_join.html_safe
  end
  
  def page_turner(target, options = {})
    options.merge! :container => true, :page_links => false,
                   :previous_label => "Previous", :next_label => "Next",
                   :class => "page-turner clear"
    will_paginate(target, options)
  end
end
