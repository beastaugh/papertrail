module BooksHelper
  def edit_link(book, link_options = {})
    if admin?
      content_tag :p, link_to(link_options[:link_name] || "Edit book &raquo;", :controller => "books", :action => "edit", :id => book.permalink), :class => "edit"
		end
	end
	
	def nice_date(given_date)
    given_date.strftime("%A %e %B %Y")
  end
end