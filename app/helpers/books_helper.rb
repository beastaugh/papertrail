module BooksHelper
  def edit_link(book, link_options = {})
    if admin?
      link_to(link_options[:link_name] || "Edit",
        {:action => "edit", :id => book.permalink},
        {:class => "edit button"})
		end
	end
	
	def nice_date(given_date)
    given_date.strftime("%A %e %B %Y")
  end
end