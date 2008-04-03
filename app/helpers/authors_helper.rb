module AuthorsHelper
  def edit_link(author)
    if admin?
      content_tag :p, link_to("Edit author &raquo;", :action => "edit", :id => author.permalink), :class => "edit"
		end
	end
end